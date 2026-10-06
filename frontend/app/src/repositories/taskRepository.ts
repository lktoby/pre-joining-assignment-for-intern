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