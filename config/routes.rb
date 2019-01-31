Rails.application.routes.draw do
  get 'teachers/list_teac'
  resources :students
  root 'static_pages#index'

  get 'signup', to: 'admins#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  get 'list/presentations', to: 'admins#list_pres'
  get 'list/teachers', to: 'admins#list_teac'
  get 'list/students', to: 'admins#list_stud'

  post 'admin/new', to: 'admins#create'
  post 'teacher/new', to: 'admins#new_teac'

  get 'dashboard', to: 'admins#dashboard'

  get 'settings', to: 'admins#settings'

  get 'mailer', to: 'admins#mailer'

  get 'upload/teachers', to: 'admins#upload_teac'
  post 'upload/teachers', to: 'admins#import_teachers'

  get 'upload/students', to: 'admins#upload_stud'
  post 'upload/students', to: 'admins#import_students'

  get 'upload/presentations', to: 'admins#upload_pres'
  post 'upload/presentations', to: 'admins#import_presentations'

  get 'upload/presenta', to: 'admins#upload_stud'

  get 'reset', to: 'admins#reset'
  get 'confirm', to: 'admins#clear'

  resources :admins
  resources :students
  resources :presentations
  resources :sessions, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
