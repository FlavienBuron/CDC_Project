# Group 7 Project : Distributed File-System

## Creating the docker containers

1. Make sure you are in the correct folder:
```
$ ./cdc_project
```

2. To launch the full DFS, use the following command:
```
$ docker-compose up
```
This way you can observe the logs of the different parts of the project

To launch without the logs use:
```
$ docker-compose up -d
```

## Using the frontend client

1. Once the containers are running open in your browser `http://localhost:3000` to access the client.

**IMPORTANT: For the DFS to properly run using the frontend you need to make sure that your browser accepts CORS rules, including for PATCH**

2. Once you have access to the frontend you can interact with the different buttons present.

    * **Get all files**: retrieve all the files present. Used for debugging, as proof of functionality and to know which files are present.
    * **Get file**: retrieve the specified file regardless of the user. Used for debugging and as proof
    * **Get file for user**: Retrieve the files for the specified user
    * **Upload file for user**: Add a new file to the file list, created by the specified user.

    When files are displayed you can update them (simulate as if the user modified the file) to update the "Modified on" timestamp. Only a user with a 'write' permissions can update a file. Once updated, reload the list by using on the "Get" button to see the updated field.

    Unfortunately the functionality to share a file to a user or delete a file is not implemented, therefore the "Delete" button does nothing, and there is no button to add a user to a file (but the functionality exists in the backend).

## Removing the containers

Once you are done with testing our DFS you can remove the containers simply by running
```
$ docker-compose down
```

## Using the DFS directly from the backend

If you want to use the DFS without using the frontend, whether to test the functionalities directly or because the frontend doesn't work, you can do so by using
```
$ docker-compose run backend
```
This will create the necessary containers if they do not exist yet.

In you console you should be a see an Elixir shell running for the backend, with which you can interact to "simulate" client requests and get the result.

To use a functionality from the backend use:
```
iex(backend@backend)1> Backend.XXXXX
```

Where XXXXX stands for the following possible functions:

* get(): return the JSON string containing all files
* get_files(user): return the JSON string of the files for which the user has access
* get_file(filename): return the JSON string of the specified file
* post(filename, user): create a new file, created by the user. Return the new list of files
* update(filename, by_username, new_username, is_owner, permissions): add a new user (new_username) to the file (filename), if user requesting the update (by_username) has correct permission (==owner). The new user will have the ownership status and permissions defined in is_owner (boolean) and permissions (integer, 1 to 7). If ownership is true the permissions are set to 7 regardless of the specified number, and vice versa.
* update(filename, username): update the timestamp of the specified file if the user requesting the action has the correct permissions