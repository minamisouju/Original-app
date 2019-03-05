require 'rails_helper'

RSpec.describe Content, type: :model do
  context 'present' do
    content = Content.new(original_text:"present", converted_text:"present")
    it "is valid with original_text and converted_text" do
      expect(content).to be_valid
    end
  end
  context 'empty' do
    it "is invalid without original_text" do
      content = Content.new(original_text:"", converted_text:"present")
      content.valid?
      expect(content.errors[:original_text]).to include("can't be blank")
    end
    it "is invalid without converted_text" do
      content = Content.new(original_text:"present", converted_text:"")
      content.valid?
      expect(content.errors[:converted_text]).to include("can't be blank")
    end
  end
end
