export async function createTask(taskBody: string, csrfToken: string): Promise<Response> {
    return fetch('/api/tasks', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken,
        },
        body: JSON.stringify({
            "task": {
                "body": taskBody
            }}),
        credentials: 'include',
    });
}

 export async function getTasks(type: string, page: number, csrfToken: string): Promise<Response> {
    const response = await fetch(`/api/tasks?type=${type}&page=${page}`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken,
        },
        credentials: 'include',
    });
    
    return response;
}