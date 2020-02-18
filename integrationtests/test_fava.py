from .framework import IntegrationTest


class FavaTestCase(IntegrationTest):
    """Fava 1.13 uses setuptools-scm in its setup.cfg.  We test if we can
    at least handle thos packages without crashing
    """

    name_of_testcase = "fava"
    requirements = ["fava==1.13"]
