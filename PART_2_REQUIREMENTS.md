# MyBasecamp1 - Part 2: Projects Implementation

## 📋 Overview

This document outlines the requirements for **Part 2: Projects CRUD Operations**. Your colleague (Person B) should use this guide to implement the Projects feature that allows users to create, view, update, and delete projects.

**Responsible Developer:** Zlata Daskevica  
**Timeline:** After Part 1 (Users, Sessions & Roles) is complete  

---

## 🎯 Part 2 Responsibilities

Implement full CRUD operations for Projects:
- Users should be able to **create projects**
- Users should be able to **view their projects**
- Users should be able to **edit projects** (owner only)
- Users should be able to **delete projects** (owner only)
- Only **project owners** can edit/delete their projects
- Projects should show **owner information**

---

## 📐 Technical Specifications

### 1️⃣ Project Model & Database

#### Generate Project Model
```bash
rails generate model Project name:string description:text user:references
rails db:migrate
```

#### Fields Required
| Field | Type | Validation | Notes |
|-------|------|-----------|-------|
| `name` | string | presence, uniqueness (per user) | Project name |
| `description` | text | presence | Project details |
| `user_id` | integer (FK) | presence | Owner reference |
| `created_at` | datetime | auto | Timestamp |
| `updated_at` | datetime | auto | Timestamp |

#### Model Code (app/models/project.rb)
```ruby
class Project < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :description, presence: true
  validates :user_id, presence: true
end
```

#### Update User Model (app/models/user.rb)
```ruby
# Add this association:
has_many :projects, dependent: :destroy
```

---

### 2️⃣ Projects Controller

#### Generate Controller
```bash
rails generate controller Projects
```

#### Actions Required
| Action | HTTP | Purpose | Authorization |
|--------|------|---------|-----------------|
| `new` | GET | Show create form | Logged-in users |
| `create` | POST | Create project | Logged-in users |
| `index` | GET | List all projects | Public or filtered |
| `show` | GET | View single project | Public |
| `edit` | GET | Show edit form | Owner only |
| `update` | PATCH | Update project | Owner only |
| `destroy` | DELETE | Delete project | Owner only |

#### Controller Code (app/controllers/projects_controller.rb)
```ruby
class ProjectsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner, only: [:edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def show
    # @project is set by set_project
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      redirect_to @project, notice: "Project created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project deleted successfully!"
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end

  def authorize_owner
    unless @project.user == current_user || current_user&.admin?
      redirect_to projects_path, alert: "Not authorized"
    end
  end
end
```

---

### 3️⃣ Routes Configuration

Update `config/routes.rb`:
```ruby
Rails.application.routes.draw do
  root "pages#home"

  resources :users, only: [:new, :create, :index, :show, :destroy, :edit, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :projects  # All 7 RESTful routes

  get "login", to: "sessions#new", as: "login"
  delete "logout", to: "sessions#destroy", as: "logout"

  get "up" => "rails/health#show", as: :rails_health_check
end
```

---

### 4️⃣ Views Required

#### 1. Projects Index (app/views/projects/index.html.erb)
Shows all projects with ability to create new one
```erb
<h1>All Projects</h1>

<%= link_to "Create New Project", new_project_path, class: "btn" %>

<table border="1">
  <thead>
    <tr>
      <th>Name</th>
      <th>Owner</th>
      <th>Description</th>
      <th>Created</th>
      <th>Actions</th>
    </tr>
  </thead>
  <tbody>
    <% @projects.each do |project| %>
      <tr>
        <td><strong><%= project.name %></strong></td>
        <td><%= project.user.name %></td>
        <td><%= truncate(project.description, length: 50) %></td>
        <td><%= project.created_at.strftime("%b %d, %Y") %></td>
        <td>
          <%= link_to "View", project_path(project) %>
          <% if project.user == current_user || current_user&.admin? %>
            <%= link_to "Edit", edit_project_path(project) %>
            <%= link_to "Delete", project_path(project), method: :delete, data: { confirm: "Are you sure?" } %>
          <% end %>
        </td>
      </tr>
    <% end %>
  </tbody>
</table>
```

#### 2. Project Show (app/views/projects/show.html.erb)
Display single project details
```erb
<div class="card">
  <h1><%= @project.name %></h1>
  
  <p>
    <strong>Owner:</strong> 
    <%= link_to @project.user.name, user_path(@project.user) %>
  </p>
  
  <p>
    <strong>Description:</strong><br>
    <%= simple_format(@project.description) %>
  </p>
  
  <p>
    <strong>Created:</strong> 
    <%= @project.created_at.strftime("%B %d, %Y at %l:%M %p") %>
  </p>

  <div class="actions">
    <%= link_to "Back to Projects", projects_path %>
    
    <% if @project.user == current_user || current_user&.admin? %>
      <%= link_to "Edit", edit_project_path(@project), class: "btn" %>
      <%= link_to "Delete", project_path(@project), method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-danger" %>
    <% end %>
  </div>
</div>
```

#### 3. New Project (app/views/projects/new.html.erb)
Form to create new project
```erb
<h1>Create New Project</h1>

<%= form_with model: @project, local: true do |f| %>
  <% if @project.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@project.errors.count, "error") %> prohibited this project from being saved:</h2>
      <ul>
        <% @project.errors.full_messages.each do |message| %>
          <li><%= message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div>
    <%= f.label :name %><br>
    <%= f.text_field :name %>
  </div>

  <div>
    <%= f.label :description %><br>
    <%= f.textarea :description %>
  </div>

  <div>
    <%= f.submit "Create Project" %>
  </div>
<% end %>

<%= link_to "Back to Projects", projects_path %>
```

#### 4. Edit Project (app/views/projects/edit.html.erb)
Form to update project (same as new but for editing)
```erb
<h1>Edit Project</h1>

<%= form_with model: @project, local: true do |f| %>
  <% if @project.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@project.errors.count, "error") %> prohibited this project from being saved:</h2>
      <ul>
        <% @project.errors.full_messages.each do |message| %>
          <li><%= message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div>
    <%= f.label :name %><br>
    <%= f.text_field :name %>
  </div>

  <div>
    <%= f.label :description %><br>
    <%= f.textarea :description %>
  </div>

  <div>
    <%= f.submit "Update Project" %>
  </div>
<% end %>

<%= link_to "Back to Project", @project %>
```

---

### 5️⃣ Update Navigation

Add Projects link to navbar in `app/views/layouts/application.html.erb`:

```erb
<% if logged_in? %>
  <span class="user-welcome">Welcome, <%= current_user.name %></span>
  <%= link_to "My Profile", user_path(current_user) %>
  <%= link_to "All Users", users_path %>
  <%= link_to "Projects", projects_path %>  <!-- ADD THIS LINE -->
  <%= link_to "Log Out", logout_path, method: :delete, data: { confirm: "Are you sure?" } %>
<% else %>
  ...
<% end %>
```

---

## 📋 Checklist for Implementation

### Model & Database
- [ ] Generate Project model with correct fields
- [ ] Create and run migration
- [ ] Add association to User model (`has_many :projects`)
- [ ] Add validation for name (presence, uniqueness per user)
- [ ] Add validation for description (presence)

### Controller
- [ ] Create ProjectsController with all 7 actions
- [ ] Add before_action callbacks for authentication & authorization
- [ ] Implement `authorize_owner` method
- [ ] Build project with current_user (not mass-assign user_id)
- [ ] Add error handling for invalid data

### Routes
- [ ] Add `resources :projects` to routes.rb

### Views
- [ ] Create `app/views/projects/` directory
- [ ] Create `index.html.erb` - list all projects
- [ ] Create `show.html.erb` - single project view
- [ ] Create `new.html.erb` - create form
- [ ] Create `edit.html.erb` - edit form
- [ ] Ensure forms have error messages
- [ ] Add proper authorization checks in views

### Navigation
- [ ] Add "Projects" link to navbar
- [ ] Test that link works correctly

---

## 🧪 Testing Checklist

**User Story 1: Create Project**
- [ ] Logged-in user can click "Create New Project"
- [ ] Form appears with name and description fields
- [ ] User enters data and clicks submit
- [ ] Project is created and user is redirected to show page
- [ ] Success message displays

**User Story 2: View Projects**
- [ ] All projects display in index view
- [ ] Each project shows owner name
- [ ] Can click on project to view details
- [ ] Project show page displays all information

**User Story 3: Edit Project**
- [ ] Only owner can see Edit link
- [ ] Only admin or owner can access edit page
- [ ] Edit form pre-fills current data
- [ ] Changes are saved successfully

**User Story 4: Delete Project**
- [ ] Only owner can see Delete link
- [ ] Only admin or owner can delete
- [ ] Confirm dialog appears before delete
- [ ] Project is removed from database
- [ ] User redirected to projects index

**Security**
- [ ] Non-owner cannot edit other's projects
- [ ] Non-owner cannot delete other's projects
- [ ] Logged-out user cannot create projects
- [ ] Admin can manage any project

---

## 🔗 Useful Rails Commands

```bash
# Generate model
rails generate model Project name:string description:text user:references

# Run migrations
rails db:migrate

# Generate controller
rails generate controller Projects

# Rails console (test queries)
rails console

# Test model associations
user = User.first
user.projects.create(name: "Test", description: "Test project")
```

---

## 📚 Key Concepts to Review

1. **Associations** - `belongs_to`, `has_many`, `dependent: :destroy`
2. **Validations** - `:scope`, `presence`, `uniqueness`
3. **Authorization** - Check ownership before allowing edits
4. **RESTful Routing** - Understanding standard 7 RESTful actions
5. **before_action** callbacks - Reusing code across actions
6. **Form Building** - Rails form helpers with models

---

## 💡 Pro Tips

- Use `current_user.projects.build()` to automatically set the user_id
- Use `dependent: :destroy` so projects are deleted when user is deleted
- Add error messages in views for better UX
- Test authorization thoroughly to prevent unauthorized access
- Use `truncate` helper to shorten long descriptions in index view

---

## ❓ Questions or Blockers?

If you get stuck:
1. Check Rails console: `rails console`
2. Verify associations: `User.find(1).projects`
3. Check database: `rails db:migrate status`
4. Review error messages carefully
5. Ask for help early!

---

**Good luck! This builds the core feature of Basecamp! 🚀**
