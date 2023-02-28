import logging

import azure.functions as func

from common.package_03 import data


def main(myreq: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    logging.info(f'The request is {myreq}')

    try:

        json_value = myreq.get_json()

        msg = f'The JSON in this request is {json_value}'
        logging.info(msg)
        df = data(**json_value)

        msg_result = f'The DataFrame with random values is:\n{df.to_string()}'

        logging.info(msg_result)
        return func.HttpResponse(msg_result, status_code=200)

    except ValueError:
        msg = 'Error, the request does not contain a JSON on its body'
        logging.error(msg)
        return func.HttpResponse(msg, status_code=500)
