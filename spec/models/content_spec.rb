require 'rails_helper'

RSpec.describe Content, type: :model do
  before do
    @content = build(:content)
  end
  #let(:content){ build(:content) }
  subject { @content.valid? }

  describe 'validation' do

    context 'with valid' do
      it 'valid' do
        is_expected.to eq(true)
        expect(@content.errors).to be_empty
      end
    end

    context 'with nil' do
      it 'reject nil original' do
        @content.original_text = nil
        is_expected.to eq(false)
        expect(@content.errors[:original_text].to_s).to include("blank")
      end
      #before_validationで変更されるため、valid
      it 'valid nil converted' do
        @content.converted_text = nil
        is_expected.to eq(true)
      end
    end

    context 'with blank' do
      it 'reject blank original' do
        @content.original_text = ""
        is_expected.to eq(false)
        expect(@content.errors[:original_text].to_s).to include("blank")
      end
      it 'valid blank converted' do
        @content.converted_text = ""
        is_expected.to eq(true)
      end
    end
    context 'with longer text' do
      it 'reject too long original' do
        @content.original_text = "a" * 141
        is_expected.to eq(false)
        expect(@content.errors[:original_text].to_s).to include("too_long")
      end
      it 'valid too long converted' do
        @content.converted_text = "a" * 141
        is_expected.to eq(true)
      end
    end
  end
end
