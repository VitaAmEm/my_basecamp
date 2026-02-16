# Welcome to My Basecamp 1
***

## Task
The goal of this project is to recreate core features of Basecamp using a Ruby on Rails MVC architecture. The main challenge was to implement a full-stack web application with user authentication, role management (admin/user), proper authorization, good user experience, project CRUD operations.

## Description
The platform allows users to register securely using encrypted passwords, sign in and sign out through session management, and manage their personal profiles. The system supports role management, allowing users to be promoted to administrators or have administrative privileges removed. Authenticated users can create new projects, view project details, update existing projects, and delete projects when authorized.

## Installation
1) Clone the repository and enter the project folder:
git clone https://github.com/VitaAmEm/my_basecamp.git
cd my_basecamp

2) Install dependencies (gems):
bundle install

3) Create and setup the database:
rails db:create
rails db:migrate

4) Start the Rails server:
rails server

5) Open in browser:
http://localhost:3000

## Usage
After starting the server, open a web browser and navigate to http://localhost:3000
. From there, a new user can register an account and will be automatically authenticated. Authenticated users can create and manage projects through the interface. Project owners and administrators have permission to update or delete projects, while regular users are restricted to their own resources. Administrators additionally have the ability to manage user roles within the platform.

### The Core Team
Zlata - project model and migration, a ProjectsController with all RESTful actions, routes and views, plus owner/admin authorization.