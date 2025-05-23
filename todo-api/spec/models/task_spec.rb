require 'rails_helper'

RSpec.describe Task, type: :model do
  # Validation tests
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:due_date) }
    it { should validate_presence_of(:priority) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:priority).in_array([1, 2, 3]) }
    it { should validate_inclusion_of(:status).in_array(['incomplete', 'complete']) }
  end

  # Scope tests
  describe 'scopes' do
    before do
      # Create test data
      create(:task, status: 'incomplete', priority: 1, due_date: 1.day.from_now)
      create(:task, status: 'incomplete', priority: 2, due_date: 2.days.from_now)
      create(:task, status: 'complete', priority: 3, due_date: 3.days.from_now)
      create(:task, status: 'complete', priority: 1, due_date: 4.days.from_now)
    end

    describe '.by_status' do
      it 'returns tasks with the specified status' do
        expect(Task.by_status('incomplete').count).to eq(2)
        expect(Task.by_status('complete').count).to eq(2)
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

    describe '.sorted_by_priority_asc' do
      it 'returns tasks sorted by priority in ascending order' do
        tasks = Task.sorted_by_priority_asc
        expect(tasks.first.priority).to be <= tasks.last.priority
      end
    end

    describe '.sorted_by_priority_desc' do
      it 'returns tasks sorted by priority in descending order' do
        tasks = Task.sorted_by_priority_desc
        expect(tasks.first.priority).to be >= tasks.last.priority
      end
    end
  end

  # Class method tests
  describe '.sort_by_field' do
    before do
      # Create test data
      create(:task, priority: 1, due_date: 1.day.from_now)
      create(:task, priority: 2, due_date: 2.days.from_now)
      create(:task, priority: 3, due_date: 3.days.from_now)
    end

    context 'when sorting by dueDate' do
      it 'sorts in ascending order when direction is asc' do
        tasks = Task.sort_by_field('dueDate', 'asc')
        expect(tasks.first.due_date).to be < tasks.last.due_date
      end

      it 'sorts in descending order when direction is desc' do
        tasks = Task.sort_by_field('dueDate', 'desc')
        expect(tasks.first.due_date).to be > tasks.last.due_date
      end
    end

    context 'when sorting by priority' do
      it 'sorts in ascending order when direction is asc' do
        tasks = Task.sort_by_field('priority', 'asc')
        expect(tasks.first.priority).to be <= tasks.last.priority
      end

      it 'sorts in descending order when direction is desc' do
        tasks = Task.sort_by_field('priority', 'desc')
        expect(tasks.first.priority).to be >= tasks.last.priority
      end
    end

    context 'when sorting by an invalid field' do
      it 'returns all tasks without sorting' do
        expect(Task.sort_by_field('invalid', 'asc').count).to eq(Task.count)
      end
    end
  end
end

