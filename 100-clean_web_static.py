#!/usr/bin/python3
# Fabfile to del out-of-date archives.
import os
from fabric import Connection, task

env = {"hosts": ["34.232.69.124", "34.207.83.226"]}

@task
def do_clean(c, number=0):
    """Delete out-of-date archives.

    Args:
        c (Connection): Fabric connection object.
        number (int): The number of archives to keep.

    If number is 0 or 1, keeps only the most recent archive. If
    number is 2, keeps the most and second-most recent archives,
    etc.
    """
    number = max(1, int(number))

    # Loca cleanup
    local_archives = sorted(os.listdir("versions"))
    for archive in local_archives[:-number]:
        c.local(f"rm versions/{archive}")

    # Remot cleanup
    with c.cd("/data/web_static/releases"):
        remote_archives = c.run("ls -tr | grep 'web_static_'", hide=True).stdout.split()
        for archive in remote_archives[:-number]:
            c.run(f"rm -rf {archive}")

if __name__ == "__main__":
    connection = Connection(env["hosts"][0])  # Use the first host by default
    do_clean(connection)

