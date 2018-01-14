FROM jupyter/scipy-notebook:400c69639ea5

USER root
RUN apt-get update && apt-get install --yes --no-install-recommends cifs-utils

ADD mount.bash /usr/local/sbin/mount.bash

ENTRYPOINT ["/usr/local/sbin/mount.bash"]
