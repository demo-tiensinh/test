require 'rails_helper'

RSpec.describe Task, type: :model do
  # Validation tests
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:due_date) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(['to_do', 'in_progress', 'done']) }
  end

  # Scope tests
  describe 'scopes' do
    before do
      # Create test data
      create(:task, status: 'to_do', due_date: 1.day.from_now)
      create(:task, status: 'in_progress', due_date: 2.days.from_now)
      create(:task, status: 'done', due_date: 3.days.from_now)
      create(:task, status: 'to_do', due_date: 4.days.from_now)
    end

    describe '.by_status' do
      it 'returns tasks with the specified status' do
        expect(Task.by_status('to_do').count).to eq(2)
        expect(Task.by_status('in_progress').count).to eq(1)
        expect(Task.by_status('done').count).to eq(1)
      end
    end

    describe '.sorted_by_due_date_asc' do
      it 'returns tasks sorted by due_date in ascending order' do
        tasks = Task.sorted_by_due_date_asc
        expect(tasks.first.due_date).to be < tasks.last.due_date
      end
    end

    describe '.sorted_by_due_date_desc' do
      it 'returns tasks sorted by due_date in descending order' do
        tasks = Task.sorted_by_due_date_desc
        expect(tasks.first.due_date).to be > tasks.last.due_date
      end
    end
  end

  # Class method tests
  describe '.sort_by_field' do
    before do
      # Create test data
      create(:task, due_date: 1.day.from_now)
      create(:task, due_date: 2.days.from_now)
      create(:task, due_date: 3.days.from_now)
    end

    context 'when sorting by due_date_asc' do
      it 'sorts in ascending order' do
        tasks = Task.sort_by_field('due_date_asc')
        expect(tasks.first.due_date).to be < tasks.last.due_date
      end
    end

    context 'when sorting by due_date_desc' do
      it 'sorts in descending order' do
        tasks = Task.sort_by_field('due_date_desc')
        expect(tasks.first.due_date).to be > tasks.last.due_date
      end
    end

    context 'when sorting by an invalid field' do
      it 'returns all tasks without sorting' do
        expect(Task.sort_by_field('invalid').count).to eq(Task.count)
      end
    end
  end
end
