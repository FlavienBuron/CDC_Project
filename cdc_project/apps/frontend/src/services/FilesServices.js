
export async function getFileForUser(username) {

    try{
        const res = await fetch("http://0.0.0.0:8080/api/getFilesTest", {
            method: "GET",
            mode: "cors",
            cache: "no-cache",
            headers: {"Content-Type": "application/json"}
        });
        const response = await res.json();
        console.log(response);
        return response;
    }catch(error) {
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
