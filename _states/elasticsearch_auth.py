"""
Wrapper to bootstrap Elasticsearch authentication.

This is not a proper module for general tasks.
"""

from salt.exceptions import CommandExecutionError, SaltInvocationError

__virtualname__ = "elasticsearch_auth"


def __virtual__():
    return __virtualname__


def check_bootstrap_pass_was_reset(name, auth_password, api_url=None):
    """
    Checks whether the password is valid for the user and returns the opposite.

    This is essentially a convenience function.
    """
    return {
        "name": name,
        "comment": "",
        "changes": {},
        "result": not __salt__["elasticsearch_auth.authenticate"](
            auth_password, auth_user=name, api_url=api_url
        ),
    }


def role_present(
    name,
    auth_password,
    applications=None,
    cluster=None,
    metadata=None,
    run_as=None,
    api_url=None,
    auth_user="elastic",
):
    ret = {
        "name": name,
        "comment": "The role is present as specified.",
        "changes": {},
        "result": True,
    }

    try:
        changes = {}
        current = None
        current_list = __salt__["elasticsearch_auth.list_roles"](
            auth_password, auth_user=auth_user, api_url=api_url
        )
        if name in current_list:
            current = __salt__["elasticsearch_auth.get_role"](
                name, auth_password, auth_user=auth_user, api_url=api_url
            )
            for param, val in [
                ("applications", applications),
                ("cluster", cluster),
                ("metadata", metadata),
                ("run_as", run_as),
            ]:
                if val is None:
                    continue
                if current[name].get(param) != val:
                    changes[param] = {"old": current[name].get(param), "new": val}
        if not changes and current:
            return ret

        ret["changes"] = changes or {"created": name}
        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = (
                "The role would have been " + "created" if not current else "updated"
            )
            return ret
        __salt__["elasticsearch_auth.write_role"](
            name,
            auth_password,
            applications=applications,
            cluster=cluster,
            metadata=metadata,
            run_as=run_as,
            auth_user=auth_user,
            api_url=api_url,
        )
        ret["comment"] = "The role has been " + "created" if not current else "updated"

    except CommandExecutionError as err:
        ret["result"] = False
        ret["comment"] = str(err)
        ret["changes"] = {}
    return ret


def role_absent(
    name,
    auth_password,
    api_url=None,
    auth_user="elastic",
):
    ret = {
        "name": name,
        "comment": "The role is already absent.",
        "changes": {},
        "result": True,
    }

    try:
        current_list = __salt__["elasticsearch_auth.list_roles"](
            auth_password, auth_user=auth_user, api_url=api_url
        )
        if name not in current_list:
            return ret

        ret["changes"]["deleted"] = name

        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "The role would have been deleted"
            return ret
        __salt__["elasticsearch_auth.delete_role"](
            name, auth_password, auth_user=auth_user, api_url=api_url
        )
        ret["comment"] = "The role has been deleted"

    except CommandExecutionError as err:
        ret["result"] = False
        ret["comment"] = str(err)
        ret["changes"] = {}
    return ret


def user_present(
    name,
    auth_password,
    enabled=True,
    email=None,
    full_name=None,
    metadata=None,
    init_password=None,
    init_password_hash=None,
    roles=None,
    api_url=None,
    auth_user="elastic",
):
    ret = {
        "name": name,
        "comment": "The user is present as specified.",
        "changes": {},
        "result": True,
    }

    try:
        changes = {}
        current = None
        current_list = __salt__["elasticsearch_auth.list_users"](
            auth_password, auth_user=auth_user, api_url=api_url
        )
        if name in current_list:
            current = __salt__["elasticsearch_auth.get_user"](
                name, auth_password, auth_user=auth_user, api_url=api_url
            )
            for param, val in [
                ("enabled", enabled),
                ("email", email),
                ("full_name", full_name),
                ("metadata", metadata),
                ("roles", roles),
            ]:
                if val is None:
                    continue
                if current[name].get(param) != val:
                    changes[param] = {"old": current[name].get(param), "new": val}
        if not changes and current:
            return ret

        ret["changes"] = changes or {"created": name}
        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = (
                "The user would have been " + "created" if not current else "updated"
            )
            return ret
        if current:
            init_password = init_password_hash = None
        __salt__["elasticsearch_auth.write_user"](
            name,
            auth_password,
            enabled=enabled,
            email=email,
            full_name=full_name,
            metadata=metadata,
            password=init_password,
            password_hash=init_password_hash,
            roles=roles,
            auth_user=auth_user,
            api_url=api_url,
        )
        ret["comment"] = "The user has been " + "created" if not current else "updated"

    except CommandExecutionError as err:
        ret["result"] = False
        ret["comment"] = str(err)
        ret["changes"] = {}
    return ret


def user_absent(
    name,
    auth_password,
    api_url=None,
    auth_user="elastic",
):
    ret = {
        "name": name,
        "comment": "The user is already absent.",
        "changes": {},
        "result": True,
    }

    try:
        current_list = __salt__["elasticsearch_auth.list_users"](
            auth_password, auth_user=auth_user, api_url=api_url
        )
        if name not in current_list:
            return ret

        ret["changes"]["deleted"] = name
        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "The user would have been deleted"
            return ret
        __salt__["elasticsearch_auth.delete_user"](
            name, auth_password, auth_user=auth_user, api_url=api_url
        )
        ret["comment"] = "The user has been deleted"

    except CommandExecutionError as err:
        ret["result"] = False
        ret["comment"] = str(err)
        ret["changes"] = {}
    return ret


def password_reset(
    name,
    old_password,
    password=None,
    password_pillar=None,
    password_hash=None,
    api_url=None,
):
    ret = {
        "name": name,
        "comment": "The user's password does not match the old password.",
        "changes": {},
        "result": True,
    }

    try:
        if not (password or password_pillar or password_hash):
            raise SaltInvocationError("Either password or password_pillar is necessary")

        if not __salt__["elasticsearch_auth.authenticate"](
            old_password, auth_user=name
        ):
            return ret

        if password or password_pillar:
            password = password or __salt__["pillar.get"](password_pillar)

        ret["changes"] = {"password": True}

        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "The user's password would have been reset"
            return ret

        __salt__["elasticsearch_auth.change_password"](
            old_password,
            auth_user=name,
            password=password,
            password_hash=password_hash,
            api_url=api_url,
        )

    except (CommandExecutionError, SaltInvocationError) as err:
        ret["result"] = False
        ret["comment"] = str(err)
        ret["changes"] = {}
    return ret
