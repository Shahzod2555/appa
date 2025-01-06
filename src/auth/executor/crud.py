from fastapi import HTTPException
from sqlalchemy import select, and_
from sqlalchemy.ext.asyncio import AsyncSession

from .schema import RegisterSchemaExecutor, ResponseExecutor, LoginSchemaExecutor, CurrentExecutor
from ..hash_pwd import hash_password, verify_password
from ...models import Executor


# create executor
async def crate_executor(session: AsyncSession, user_data: RegisterSchemaExecutor) -> ResponseExecutor:
    new_executor = Executor(email=user_data.email, phone_number=user_data.phone_number, hash_password=hash_password(user_data.password), first_name=user_data.first_name,)
    session.add(new_executor)
    await session.commit()
    await session.refresh(new_executor)
    return ResponseExecutor.model_validate(new_executor)


# get executor
async def login_executor(session: AsyncSession, user_data: LoginSchemaExecutor, condition) -> ResponseExecutor:
    result = await session.execute(select(Executor).where(condition))
    executor = result.scalar_one_or_none()

    if not executor or not verify_password(user_data.password, executor.hash_password):
        raise HTTPException(status_code=400, detail="Неверный номер телефона, email или пароль.")

    return ResponseExecutor.model_validate(executor)


# get current executor
async def get_current_executor(session: AsyncSession, user_data: CurrentExecutor) -> ResponseExecutor:
    result = await session.execute(
        select(Executor).where(
            and_(
                Executor.email == user_data.email,
                Executor.phone_number == user_data.phone_number
            )
        )
    )
    executor = result.scalar_one_or_none()
    if not executor:
        raise HTTPException(
            status_code=400,
            detail="Пользователь с таким email или номером телефона не существует"
        )
    return ResponseExecutor.model_validate(executor)


# get executors
async def get_executors(session: AsyncSession) -> list[ResponseExecutor]:
    result = await session.execute(select(Executor))
    executors = result.scalars().all()
    return [ResponseExecutor.model_validate(executor) for executor in executors]
