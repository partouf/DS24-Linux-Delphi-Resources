import requests
import os

from approvaltests.approvals import verify_as_json, verify

api_url = os.environ['PUBLIC_URL']

class TestForSmoke:
    def get_books(self):
        r = requests.get(f"{api_url}/books/")
        return r.json()

    def test_healthcheck(self):
        r = requests.get(f"{api_url}/checks/health")
        verify(f'{r.status_code}: {r.text}')

    def test_books(self):
        verify_as_json(self.get_books())
