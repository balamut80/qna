shared_examples_for "private publication" do

	it "published for channel" do
		expect(PrivatePub).to receive(:publish_to).with(publish_channel, anything)
		do_request
	end

end
