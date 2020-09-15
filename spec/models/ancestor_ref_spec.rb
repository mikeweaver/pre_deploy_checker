require 'spec_helper'

describe AncestorRef do
  let(:ancestor_ref) { described_class.new(service_name: "web", ref: "production") }
  subject { ancestor_ref }

  its(:service_name) { is_expected.to eq("web") }
  its(:ref) { is_expected.to eq("production") }

  context "validations" do
    context "when missing service name" do
      subject { described_class.new(ref: "some_ref") }

      it "is invalid" do
        expect(subject.valid?).to be false
        expect(subject.errors.full_messages).to eq ["Service name can't be blank"]
      end
    end

    context "when missing ref" do
      it "is invalid" do
        ancestor_ref.ref = nil
        expect(ancestor_ref.valid?).to be false
        expect(ancestor_ref.errors.full_messages).to eq ["Ref can't be blank"]
      end
    end
  end
end
