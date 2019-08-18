import responder
import uuid

api = responder.API()

@api.route("/")
async def uuid_api(req, resp):
    uuid_str = str(uuid.uuid4())
    resp.media = {"uuid": uuid_str}

if __name__ == '__main__':
    api.run()
