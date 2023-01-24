# frozen_string_literal: true

RSpec.describe Y::Redis, :redis, :redlock do
  it "has a version number" do
    expect(Y::Redis::VERSION).not_to be_nil
  end

  context "when syncing local and remote documents via store" do
    let(:id) { "my text" }
    let(:doc) { Y::Doc.new }
    let(:content) { "Hello, World!" }
    let(:encoded_content) do
      [
        1, 1, 176, 163, 209, 251, 12, 0, 4, 1, 7, 109, 121, 32, 116,
        101, 120, 116, 13, 72, 101, 108, 108, 111, 44, 32, 87, 111, 114,
        108, 100, 33, 0
      ]
    end

    it "stores document into store" do
      doc = Y::Doc.new
      text = doc.get_text(id)
      text << content

      store = described_class.new(redis, lock_manager)
      actual = store.save(id, doc.diff)

      expect(actual).to be(true)
    end

    it "loads document from store" do
      store = described_class.new(redis, lock_manager)
      store.save(id, encoded_content)

      update = store.load(id)

      doc.sync(update)
      text = doc.get_text(id)
      actual = text.to_s

      expect(actual).to eq("Hello, World!")
    end
  end
end
