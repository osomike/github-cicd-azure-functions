import logging

import azure.functions as func

from common.package_01 import hello
from common.package_02 import bye


def main(myreq: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    logging.info(f'The request is {myreq}')

    name = myreq.params.get('name')

    logging.info(f'The name is {name}')

    if name:
        msg = hello(name)
        return func.HttpResponse(f"{msg} This HTTP triggered function executed successfully.")
    else:
        msg = bye(name='anonymous person')
        return func.HttpResponse(
            f'This HTTP triggered function executed successfully.'
            f' Pass a name in the query string or in the request body for a personalized response. {msg}',
            status_code=200
        )

