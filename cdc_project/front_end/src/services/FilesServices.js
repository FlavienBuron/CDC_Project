
export async function getFileForUser(username) {

/*    try{
        const response = await fetch('back_end.com/api/:username');
        return await response.json();
    }catch(error) {
        return [];
    }*/

    try{
        return [{
            "users": [
                {"user": "alice", "permissions": 7, "owner": true},
                {"user": "bob","permissions": 1,"owner": false},
                {"user": "carl", "permissions": 4, "owner": false},
                {"user": "dave", "permissions": 1, "owner": false}
            ],
            "modified_on": "2021-11-30 20:10:28",
            "filename": "test.txt",
            "created_on": "2021-11-28 12:00:00"
        }];
    }catch(error) {
        console.log(error);
        return [];
    }
}

export async function setFileForUser(username,filename) {

    /*    try{
            const response = await fetch('back_end.com/api/:username');
            return await response.json();
        }catch(error) {
            return [];
        }*/

    try{
        return [{
            "users": [
                {"user": username, "permissions": 7, "owner": true}
            ],
            "modified_on": "2021-11-30 20:10:28",
            "filename": filename,
            "created_on": "2021-11-28 12:00:00"
        }];
    }catch(error) {
        console.log(error);
        return [];
    }
}
