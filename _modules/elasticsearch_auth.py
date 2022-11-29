"""
Wrapper to bootstrap Elasticsearch authentication.

This is not a proper module for general tasks.
"""
import requests
from salt.exceptions import CommandExecutionError, SaltInvocationError

__virtualname__ = "elasticsearch_auth"


def __virtual__():
    return __virtualname__


def authenticate(auth_password, auth_user="elastic", api_url=None):
    res = _query(
        "GET", "_security/_authenticate", auth_user, auth_password, api_url=api_url, raw=True
    )
    return res.ok


def change_password(
    auth_password,
    password=None,
    password_hash=None,
    user=None,
    auth_user="elastic",
    api_url=None,
):
    if not (password or password_hash):
        raise SaltInvocationError("Either password or password_hash is required")

    if user is not None:
        endpoint = f"_security/user/{user}/_password"
    else:
        endpoint = "_security/user/_password"

    payload = {}
    if password is not None:
        payload["password"] = password
    elif password_hash is not None:
        payload["password_hash"] = password_hash
    return _query(
        "POST", endpoint, auth_user, auth_password, api_url=api_url, payload=payload
    )


def get_role(role, auth_password, auth_user="elastic", api_url=None):
    return _query("GET", f"_security/role/{role}", auth_user, auth_password, api_url=api_url)


def delete_role(role, auth_password, auth_user="elastic", api_url=None):
    return _query("GET", f"_security/role/{role}", auth_user, auth_password, api_url=api_url)


def get_user(name, auth_password, auth_user="elastic", api_url=None):
    return _query("GET", f"_security/user/{name}", auth_user, auth_password, api_url=api_url)


def delete_user(name, auth_password, auth_user="elastic", api_url=None):
    return _query(
        "DELETE", f"_security/user/{name}", auth_user, auth_password, api_url=api_url
    )


def list_roles(auth_password, auth_user="elastic", api_url=None):
    return list(_query("GET", "_security/role", auth_user, auth_password, api_url=api_url))


def list_users(auth_password, auth_user="elastic", api_url=None):
    return list(_query("GET", "_security/user", auth_user, auth_password, api_url=api_url))


def write_role(
    role,
    auth_password,
    applications=None,
    cluster=None,
    metadata=None,
    run_as=None,
    auth_user="elastic",
    api_url=None,
):
    payload = {}

    if applications is not None:
        payload["applications"] = applications
    if cluster is not None:
        payload["cluster"] = cluster
    if metadata is not None:
        payload["metadata"] = metadata
    if run_as is not None:
        payload["run_as"] = run_as
    return _query(
        "POST",
        f"_security/role/{role}",
        auth_user,
        auth_password,
        api_url=api_url,
        payload=payload,
    )


def write_user(
    username,
    auth_password,
    enabled=True,
    email=None,
    full_name=None,
    metadata=None,
    password=None,
    password_hash=None,
    roles=None,
    auth_user="elastic",
    api_url=None,
):
    payload = {
        "enabled": enabled,
    }

    if email is not None:
        payload["email"] = email
    if full_name is not None:
        payload["full_name"] = full_name
    if metadata is not None:
        payload["metadata"] = metadata
    if roles is not None:
        payload["roles"] = roles
    if password is not None:
        payload["password"] = password
    elif password_hash is not None:
        payload["password_hash"] = password_hash

    return _query(
        "POST",
        f"_security/user/{username}",
        auth_user,
        auth_password,
        api_url=api_url,
        payload=payload,
    )


def _query(
    method,
    endpoint,
    auth_user,
    auth_password,
    payload=None,
    api_url="https://127.0.0.1:9200",
    raw=False,
):
    if api_url is None:
        api_url = "https://127.0.0.1:9200"
    auth = requests.auth.HTTPBasicAuth(auth_user, auth_password)
    headers = {"Content-Type": "application/json"}
    # verification only causes headaches in this context
    res = requests.request(
        method.upper(),
        f"{api_url}/{endpoint}",
        headers=headers,
        json=payload,
        auth=auth,
        verify=False,
    )
    if raw:
        return res
    try:
        res.raise_for_status()
    except requests.exceptions.HTTPError as err:
        raise CommandExecutionError(
            f"{err}: " + res.json().get("error", {}).get("reason", "")
        ) from err
    return res.json()
