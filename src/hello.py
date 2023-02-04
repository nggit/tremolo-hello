import asyncio
import os

import orjson
import uvloop

from dotenv import load_dotenv
from tremolo import Tremolo

app = Tremolo()

@app.route('/hello')
async def hello_world(content_type='application/json', **server):
    yield b'{"message":"Hello world"}'

@app.errorhandler(404)
async def err_notfound(content_type='application/json', **server):
    yield b'{"message":"%s not found!"}' % orjson.dumps(
        server['request'].path.decode(encoding='latin-1')
    )

if __name__ == '__main__':
    load_dotenv()
    asyncio.set_event_loop_policy(uvloop.EventLoopPolicy())

    try:
        host = os.getenv('HOST', '0.0.0.0')
        port = int(os.getenv('PORT', 3030))
    except ValueError:
        host = '0.0.0.0'
        port = 3030

    app.run(host=host, port=port,
        worker_num=4, download_rate=128 * 1048576, upload_rate=128 * 1048576)
