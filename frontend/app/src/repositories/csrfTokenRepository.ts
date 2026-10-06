export async function getCsrfToken(): Promise<Response> {
    return fetch('/api/csrf-token', {
        method: 'GET',
        credentials: 'include',
    });
}