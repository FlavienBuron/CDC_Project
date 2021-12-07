
export async function getFileForUser(username) {

    try{
        const res = await fetch(`http://0.0.0.0:8080/api/files/username/${username}`, {
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
        return response;
    }catch(error) {
        return [];
    }
}
export async function getAllFiles() {
    try{
        const res = await fetch(`http://0.0.0.0:8080/api/files`, {
            method: "GET",
            mode: "cors",
            cache: "no-cache",
            headers: {"Content-Type": "application/json"}
        });
        const response = await res.json();
        console.log(response.files);
        return response;
    }catch(error) {
        return [];
    }
}

export async function updateFile(filename) {
    try{
        const res = await fetch(`http://0.0.0.0:8080/api/files/${filename}`, {
            method: "PATCH",
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

export async function getFileByName(filename) {
    try{
        const res = await fetch(`http://0.0.0.0:8080/api/files/${filename}`, {
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

export async function setFileForUser(username, filename) {
    try{
        const res = await fetch(`http://0.0.0.0:8080/api/files`, {
            method: "POST",
            mode: "cors",
            cache: "no-cache",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify({ username: username, filename: filename})
        });
        const response = await res.json();
        console.log(response);
        return response;
    }catch(error) {
        return [];
    }
}


