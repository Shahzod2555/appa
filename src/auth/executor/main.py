from fastapi import APIRouter, Depends, HTTPException, Header
from sqlalchemy import select, or_
from sqlalchemy.ext.asyncio import AsyncSession

from ..jtw_ import create_access_token, decode_jwt
from ...database import get_session
from ...models import Executor
from .crud import login_executor, crate_executor, get_executors, get_current_executor
from .schema import LoginSchemaExecutor, RegisterSchemaExecutor, ResponseExecutor, CurrentExecutor

auth_executor = APIRouter()

# login auth executor
@auth_executor.post("/login-executor")
async def login_auth_executor(user_data: LoginSchemaExecutor, session: AsyncSession = Depends(get_session)):
    if user_data.email:
        condition = Executor.email == user_data.email
    elif user_data.phone_number:
        condition = Executor.phone_number == user_data.phone_number
    else:
        raise HTTPException(
            status_code=400,
            detail="Необходимо указать email или номер телефона."
        )

    user = await login_executor(session=session, user_data=user_data, condition=condition)
    return {"access_token": create_access_token(data=user.model_dump())}

# register auth executor
@auth_executor.post("/register-executor")
async def register_auth_executor(user_data: RegisterSchemaExecutor, session: AsyncSession = Depends(get_session)):
    executor_exists = await session.execute(
        select(Executor).where(
            or_(
                Executor.email == user_data.email,
                Executor.phone_number == user_data.phone_number
            )
        )
    )
    if executor_exists.scalar_one_or_none():
        raise HTTPException(
            status_code=400,
            detail="Заказчик с таким email или номером телефона уже существует"
        )

    user = await crate_executor(session=session, user_data=user_data)
    return {"access_token": create_access_token(data=user.model_dump())}

# current executor
@auth_executor.post("/current-executor")
async def register_current_executor(authorization: str = Header(), session: AsyncSession = Depends(get_session)) -> ResponseExecutor:
    if not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=400,
            detail="Неверный формат токена. Используйте Bearer токен."
        )

    decode_jwt_token = decode_jwt(token=authorization[7:])
    get_user_data = CurrentExecutor(
        email=decode_jwt_token['email'],
        phone_number=decode_jwt_token['phone_number']
    )
    current_user_data = await get_current_executor(session=session, user_data=get_user_data)
    return current_user_data

# get executor all
@auth_executor.get("/get-executor-all")
async def get_executor_all(session: AsyncSession = Depends(get_session)) -> list[ResponseExecutor]:
    return await get_executors(session=session)
