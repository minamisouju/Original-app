require 'rails_helper'

RSpec.describe Content, type: :model do
  context 'present' do
    content = Content.new(original_text:"present", converted_text:"present")
    it "is valid with original_text and converted_text" do
      expect(content).to be_valid
    end
  end
  context 'empty' do
    it "is invalid without empty" do
      content = Content.new(original_text:"", converted_text:"present")
      content.valid?
      expect(content.errors[:original_text]).to include("can't be blank")
      content.update(original_text:"present", converted_text:"")
      content.valid?
      expect(content.errors[:converted_text]).to include("can't be blank")
    end
  end
  context 'over 140' do
    it "is invalid with too long text" do
      content = Content.new(original_text:"a" * 141, converted_text:"not too long")
      content.valid?
      expect(content.errors[:original_text]).to include("is too long (maximum is 140 characters)")
      content.update(original_text:"not too long", converted_text:"a" * 141)
      content.valid?
      expect(content.errors[:converted_text]).to include("is too long (maximum is 140 characters)")
    end
  end
  context 'run COTOHA' do
    it "have genshi text" do
      content = Content.new(original_text: "犬も歩けば棒に当たる", converted_text:"犬も歩けば棒に当たる")
      expect{ content.save }.to change{ content.converted_text }.from("犬も歩けば棒に当たる").to("イヌ アル ケ バ ボウ アタ ル")
    end
  end
end
