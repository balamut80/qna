class Search
	SPHINX_INDICES = %w(Question Answer Comment User)

	def self.search(query, index = nil)
		return [] if query.blank?
		if index && SPHINX_INDICES.include?(index)
			index.constantize.search query
		else
			ThinkingSphinx.search query
		end
	end
end