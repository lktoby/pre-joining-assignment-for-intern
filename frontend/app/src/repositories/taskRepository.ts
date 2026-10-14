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

export async function getTasks(type: string, completion: string, page: number, csrfToken: string): Promise<Response> {
    const response = await fetch(`/api/tasks?type=${type}&completion=${completion}&page=${page}`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken,
        },
        credentials: 'include',
    });
    
    return response;
 }

export async function updateTask(taskId: number, completion: string, csrfToken: string): Promise<Response> {
    const response = await fetch(`/api/tasks/${taskId}/${completion}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken,
        },
        credentials: 'include',
    })
    return response;
}

export async function favoriteTask(taskId: number, isFavorited: boolean, csrfToken: string): Promise<Response> {
    const response = await fetch(`/api/tasks/${taskId}/favorite`, {
        method: isFavorited ? 'DELETE' : 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken,
        },
        credentials: 'include',
    })
    return response;
}