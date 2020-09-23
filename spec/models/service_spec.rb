# frozen_string_literal: true

require 'spec_helper'

describe Service do
  subject { described_class.new(name: "web", ref: "production") }

  its(:name) { is_expected.to eq("web") }
  its(:ref) { is_expected.to eq("production") }

  context "validations" do
    context "presence" do
      context "when missing name" do
        subject { described_class.new(ref: "some_ref") }

        it "is invalid" do
          expect(subject.valid?).to be false
          expect(subject.errors.full_messages).to eq ["Name can't be blank"]
        end
      end

      context "when missing ref" do
        subject { described_class.new(name: "uniq") }

        it "is invalid" do
          subject.ref = nil
          expect(subject.valid?).to be false
          expect(subject.errors.full_messages).to eq ["Ref can't be blank"]
        end
      end
    end

    context "uniqueness" do
      before(:all) do
        described_class.create(name: "web", ref: "production")
      end

      it "cannot have more than one record with the same service name" do
        expect(described_class.where(name: "web").count).to eq(1)

        new_service = described_class.new(name: "web", ref: "riffing")
        expect(new_service.valid?).to be false
        expect(new_service.errors.full_messages).to eq ["Name has already been taken"]
      end
    end
  end
end
