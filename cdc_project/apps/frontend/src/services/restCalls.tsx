
export async function getFileForUser(username: any) {

    try{
        console.log(`REQUEST: http://0.0.0.0:8080/api/files/users/${username}`)

        const res = await fetch(`http://0.0.0.0:8080/api/files/users/${username}`, {
            method: "GET",
            mode: "cors",
            cache: "no-cache",
            headers: {"Content-Type": "application/json"}
        });
        const response = await res.json();
        console.log(response);
        return JSON.parse(response).files;
    }catch(error) {
        return [];
    }
}

export async function stopNodes() {
    try{
        const res = await fetch(`http://0.0.0.0:8080/api/stopNodes`, {
            method: "GET",
            mode: "cors",
            cache: "no-cache",
            headers: {"Content-Type": "application/json"}
        });
        const response = await res.json();
        console.log(response);
        return JSON.parse(response).files;
    }catch(error) {
        return [];
    }
}

export async function getAllFiles() {
    try{
        console.log("REQUEST: http://0.0.0.0:8080/api/files")
        const res = await fetch(`http://0.0.0.0:8080/api/files`, {
            method: "GET",
            mode: "cors",
            cache: "no-cache",
            headers: {"Content-Type": "application/json"}
        });
        const response = await res.json();
        console.log(response);
        return JSON.parse(response).files;
    }catch(error) {
        return [];
    }
}

export async function updateFilePerm(filename: any, username: string) {
    try{
        console.log(`REQUEST: http://0.0.0.0:8080/api/files/${filename}/users/${username}`)
        const res = await fetch(`http://0.0.0.0:8080/api/files/${filename}/users/${username}`, {
            method: "PATCH",
            mode: "cors",
            cache: "no-cache",
            headers: {"Content-Type": "application/json"}
        });
        const response = await res.json();
        console.log(response);
        return JSON.parse(response).files;
    }catch(error) {
        return [];
    }
}

export async function getFileByName(filename: any) {
    try{
        console.log(`REQUEST: http://0.0.0.0:8080/api/files/${filename}`)
        const res = await fetch(`http://0.0.0.0:8080/api/files/${filename}`, {
            method: "GET",
            mode: "cors",
            cache: "no-cache",
            headers: {"Content-Type": "application/json"}
        });
        const response = await res.json();
        console.log(response);
        return [JSON.parse(response)];
    }catch(error) {
        return [];
    }
}

export async function setFileForUser(username: any, filename: any) {
    try{
        console.log(`REQUEST: http://0.0.0.0:8080/api/files`)
        const res = await fetch(`http://0.0.0.0:8080/api/files`, {
            method: "POST",
            mode: "cors",
            cache: "no-cache",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify({ username: username, filename: filename})
        });
        const response = await res.json();
        console.log(response);
        return JSON.parse(response).files;
    }catch(error) {
        return [];
    }
}

export async function updateFileForUser(username: any, filename: any, new_username: any, is_owner: any, permissions: any) {
    try{
        const res = await fetch(`http://0.0.0.0:8080/api/files`, {
            method: "PATCH",
            mode: "cors",
            cache: "no-cache",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify({ username: username, filename: filename, new_username: new_username, is_owner: is_owner, permission: permissions})
        });
        const response = await res.json();
        console.log(response);
        return JSON.parse(response).files;
    }catch(error) {
        return [];
    }
}

