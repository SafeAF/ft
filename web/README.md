# README

Here are the commands used to set up the project:

1.  Generate home controller and index action:
    ```
    rails g controller home index
    ```

2.  Install Devise:
    ```
    bundle add devise
    bundle install 
    rails g devise:install
    rails g devise User
    ```

3.  Database migration:
    ```
    rake db:migrate
    ```

4.  Generate Company scaffold:
    ```
    rails g scaffold company name contact address phone email website hours about:text category 
    rails db:migrate
    ```

5.  Install and setup Action Text:
    ```
    rails action_text:install
    rake db:migrate
    ```

6.  Add image processing gem and install Active Storage:
    ```
    apt-get install libvips
    bundle add image_processing
    bundle install
    rails active_storage:install
    rails db:migrate
    ```

7.  Generate Kaminari views for pagination:
    ```
    rails g kaminari:views bootstrap4
    ```

8.  Generate Devise views
    ```
    rails generate devise:views
    ```

9. Test

    test new dev env