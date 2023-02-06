.. _readme:

Elastic Formula
===============

|img_sr| |img_pc|

.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release
.. |img_pc| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :alt: pre-commit
   :scale: 100%
   :target: https://github.com/pre-commit/pre-commit

Manage an Elastic stack with Salt.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please refer to:

- `how to configure the formula with map.jinja <map.jinja.rst>`_
- the ``pillar.example`` file
- the `Special notes`_ section

Special notes
-------------
* This formula is written with a Vault database secret engine in mind. Note that the Vault integration currently requires my rewritten `Vault modules <https://github.com/lkubb/salt-vault-formula>`_, which might become available in Salt at some point.
* The certificate management requires my rewritten `x509 modules <https://github.com/lkubb/salt-pca-formula>`_ (for ``pkcs12``), which will be available in Salt v3006.
* ``pkcs12`` support in those modules requires ``cryptography`` v36, hence this formula includes the option to automatically upgrade it.
* All of the ``*beat`` and ``logstash`` states are boilerplate at the moment.
* The tests only serve an esthetical purpose currently (not implemented).

Configuration
-------------
An example pillar is provided, please see `pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in `map.jinja`.


Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``elastic``
^^^^^^^^^^^
Installs the Elastic repo and, if configured,
upgrades Salt's ``cryptography`` module.

Does not install/configure/start any packages/services.


``elastic.auditbeat``
^^^^^^^^^^^^^^^^^^^^^
Installs, configures and starts Auditbeat.


``elastic.auditbeat.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.auditbeat.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.auditbeat.service``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.common``
^^^^^^^^^^^^^^^^^^
Upgrades ``cryptography``, if configured.


``elastic.elasticsearch``
^^^^^^^^^^^^^^^^^^^^^^^^^
*Meta-state*.
Manages the lifecycle of an Elasticsearch node/cluster
with integration to the Vault database secret engine.

Includes all states for ES, with the exception of
`elastic.elasticsearch.vault_setup`_.


``elastic.elasticsearch.auth``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Takes care of managing ES users and groups and
managing the Vault database secret engine connection.
Also, optionally resets the bootstrap password.
Depends on `elastic.elasticsearch.service`_.


``elastic.elasticsearch.bootstrap_pass``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Ensures a known bootstrap password is set in order to
be able to manage the initial configuration non-interactively.
Depends on `elastic.elasticsearch.config`_.


``elastic.elasticsearch.certs``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Generates and manages certificates + keys for the HTTP and transport layers,
including trusted CA certificates for Elasticsearch.
Note that generally, it's advisable to setup a CA minion. See the
``x509`` (``x509_v2``) module docs for details.
Depends on `elastic.elasticsearch.package`_.


``elastic.elasticsearch.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Manages ES and JVM configuration.
Depends on `elastic.elasticsearch.package`_.


``elastic.elasticsearch.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Installs Elasticsearch only.
Depends on `elastic.repo`_.


``elastic.elasticsearch.service``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Enables and (re-)starts Elasticsearch.
Depends on `elastic.elasticsearch.config`_, `elastic.elasticsearch.certs`_
and `elastic.elasticsearch.bootstrap_pass`_


``elastic.elasticsearch.vault_roles``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Manages Vault database secret engine roles.
Depends on `elastic.elasticsearch.auth`_ (for managing
the allowed roles on the connection).


``elastic.elasticsearch.vault_setup``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This should be targeted to your Vault minion(s), not the Elasticsearch one(s).
Generates and manages ES client certificates for Vault since
the ES database plugin currently does not allow to
pass those in via the REST API.


``elastic.filebeat``
^^^^^^^^^^^^^^^^^^^^
Installs, configures and starts Filebeat.


``elastic.filebeat.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.filebeat.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.filebeat.service``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.functionbeat``
^^^^^^^^^^^^^^^^^^^^^^^^
Installs, configures and starts Functionbeat.


``elastic.functionbeat.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.functionbeat.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.functionbeat.service``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.heartbeat``
^^^^^^^^^^^^^^^^^^^^^
Installs, configures and starts Heartbeat.


``elastic.heartbeat.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.heartbeat.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.heartbeat.service``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.kibana``
^^^^^^^^^^^^^^^^^^
Installs, configures and starts Kibana, including
generating client certificates and requesting credentials
from Vault.


``elastic.kibana.auth``
^^^^^^^^^^^^^^^^^^^^^^^
Manages authentication details for Kibana.
Note that this will always report changes since there is
no way to read the current configuration.
Depends on `elastic.kibana.package`_.


``elastic.kibana.certs``
^^^^^^^^^^^^^^^^^^^^^^^^
Generates client certificates and ensures
the CA is trusted by Kibana.
Depends on `elastic.kibana.package`_.


``elastic.kibana.config``
^^^^^^^^^^^^^^^^^^^^^^^^^
Manages Kibana configuration, other than authentication.
Depends on `elastic.kibana.package`_.


``elastic.kibana.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^
Installs the Kibana package only.
Depends on `elastic.repo`_.


``elastic.kibana.service``
^^^^^^^^^^^^^^^^^^^^^^^^^^
Enables and (re-)starts Kibana.
Depends on `elastic.kibana.config`_, `elastic.kibana.certs`_
and `elastic.kibana.auth`_.


``elastic.logstash``
^^^^^^^^^^^^^^^^^^^^
Installs, configures and starts Filebeat.


``elastic.logstash.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.logstash.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.logstash.service``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.metricbeat``
^^^^^^^^^^^^^^^^^^^^^^
Installs, configures and starts Metricbeat.


``elastic.metricbeat.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.metricbeat.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.metricbeat.service``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.packetbeat``
^^^^^^^^^^^^^^^^^^^^^^
Installs, configures and starts Packetbeat.


``elastic.packetbeat.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.packetbeat.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.packetbeat.service``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.repo``
^^^^^^^^^^^^^^^^



``elastic.clean``
^^^^^^^^^^^^^^^^^
*Meta-state*.

Removes everything Elastic-related:
includes all clean states.


``elastic.auditbeat.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops, unconfigures and removes Auditbeat.


``elastic.auditbeat.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.auditbeat.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.auditbeat.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.elasticsearch.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Undoes everything in the `elastic.elasticsearch`_ state in reverse.


``elastic.elasticsearch.auth.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the Vault database connection, only if
``remove_all_data_for_sure`` is true.
Depends on `elastic.elasticsearch.service.clean`_.


``elastic.elasticsearch.bootstrap_pass.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Ensures no bootstrap password is set.
Depends on `elastic.elasticsearch.service.clean`_.


``elastic.elasticsearch.certs.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Ensures certificates and keys are removed from ES configuration
and the local filesystem.
Depends on `elastic.elasticsearch.service.clean`_.


``elastic.elasticsearch.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes Elasticsearch and JVM configuration files.
Depends on `elastic.elasticsearch.service.clean`_.


``elastic.elasticsearch.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes Elasticsearch.
Depends on `elastic.elasticsearch.config.clean`_.


``elastic.elasticsearch.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops and disables Elasticsearch at boot time.


``elastic.elasticsearch.vault_roles.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes managed Vault roles.


``elastic.elasticsearch.vault_setup.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes generated certificate and key from the Vault server's filesystem.


``elastic.filebeat.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops, unconfigures and removes Filebeat.


``elastic.filebeat.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.filebeat.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.filebeat.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.functionbeat.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops, unconfigures and removes Functionbeat.


``elastic.functionbeat.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.functionbeat.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.functionbeat.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.heartbeat.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops, unconfigures and removes Heartbeat.


``elastic.heartbeat.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.heartbeat.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.heartbeat.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.kibana.clean``
^^^^^^^^^^^^^^^^^^^^^^^^
Undoes everything in the `elastic.kibana`_ state in reverse.


``elastic.kibana.auth.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes authentication credentials from the Kibana keystore.
Depends on `elastic.kibana.service.clean`_.


``elastic.kibana.certs.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes generated Kibana certificates and keys.
Depends on `elastic.kibana.service.clean`_.


``elastic.kibana.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes Kibana the configuration file.
Depends on `elastic.kibana.service.clean`_.


``elastic.kibana.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes Kibana from the system.
Depends on `elastic.kibana.config.clean`_.


``elastic.kibana.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops and disables Kibana at boot time.


``elastic.logstash.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops, unconfigures and removes Logstash.


``elastic.logstash.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.logstash.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.logstash.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.metricbeat.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops, unconfigures and removes Metricbeat.


``elastic.metricbeat.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.metricbeat.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.metricbeat.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.packetbeat.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops, unconfigures and removes Packetbeat.


``elastic.packetbeat.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.packetbeat.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.packetbeat.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



``elastic.repo.clean``
^^^^^^^^^^^^^^^^^^^^^^




Contributing to this repo
-------------------------

Commit messages
^^^^^^^^^^^^^^^

**Commit message formatting is significant!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``. ::

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.

Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``elastic`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.
