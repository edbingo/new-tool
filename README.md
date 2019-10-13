# README NEW-TOOL

This tool aims to provide a registration page to grade 11 students, so that they can sign up for Matura presentations presented by grade 12 students. Built on ruby on rails, deployment is intended to occur on a debian server with apache2 and passenger.

Uses RUBY 2.6.0 and RAILS 5.2.2.1

## MAIL
All mail templates are stored under ~/app/views/student_mailer/
Mail is sent as HTML by default, to add TXT files, make sure to use the .txt.erb file format.

## SEEDS
The Database seed includes the default login username and password for the administrator. The seed is automatically loaded in to the database upon running the built in reset function. In case this doesn't work, run `rails db seed` from the command line in the project folder. Seeds can be modified! Just edit file ~/db/seeds.rb

## SQLITE DB
The SQLite database is stored at ~/db/production.sqlite3

## CSV
Compatible CSV files can be found at ~/CSV/

## INSTALL
This project includes a bash install script designed to be run on debian 9. Only applicable for the BKS. If the project folder has been deleted, only the usersetup script needs to be executed.

### install.sh
install.sh prepares the system for hosting and installs all dependencies. Also performs all setup related procedures.

### usersetup.sh
usersetup.sh bundles all required gems and initiates the database, as well as making feedback less verbose.
