from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .auth.customer.main import auth_customer
from .auth.executor.main import auth_executor

from .utils.lif import lifespan
from .utils.log import RequestLoggerMiddleware

def create_app():
    app = FastAPI(lifespan=lifespan)
    app.add_middleware(RequestLoggerMiddleware)
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    @app.middleware("http")
    async def add_utf8_header(request, call_next):
        response = await call_next(request)
        if "application/json" in response.headers.get("Content-Type", ""):
            response.headers["Content-Type"] = "application/json; charset=utf-8"
        return response

    app.include_router(auth_customer, tags=['customer'], prefix='/auth/customer')
    app.include_router(auth_executor, tags=['executor'], prefix='/auth/executor')

    return app
