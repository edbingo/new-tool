json.extract! student, :id, :number, :name, :surname, :mail, :created_at, :updated_at
json.url student_url(student, format: :json)
