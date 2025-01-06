from fastapi import HTTPException
from sqlalchemy import select, and_
from sqlalchemy.ext.asyncio import AsyncSession

from .schema import RegisterSchemaCustomer, ResponseCustomer, LoginSchemaCustomer, CurrentCustomer
from ..hash_pwd import hash_password, verify_password
from ...models import Customer


# create customer
async def create_customer(session: AsyncSession, user_data: RegisterSchemaCustomer) -> ResponseCustomer:
    new_customer = Customer(email=user_data.email, phone_number=user_data.phone_number, hash_password=hash_password(user_data.password), first_name=user_data.first_name,)
    session.add(new_customer)
    await session.commit()
    await session.refresh(new_customer)
    return ResponseCustomer.model_validate(new_customer)


# get customer
async def login_customer(session: AsyncSession, user_data: LoginSchemaCustomer, condition) -> ResponseCustomer:
    result = await session.execute(select(Customer).where(condition))
    customer = result.scalar_one_or_none()

    if not customer or not verify_password(user_data.password, customer.hash_password):
        raise HTTPException(status_code=400, detail="Неверный номер телефона, email или пароль.")

    return ResponseCustomer.model_validate(customer)


# get current customer
async def get_current_customer(session: AsyncSession, user_data: CurrentCustomer) -> ResponseCustomer:
    result = await session.execute(
        select(Customer).where(
            and_ (
                Customer.email == user_data.email,
                Customer.phone_number == user_data.phone_number
            )
        )
    )
    customer = result.scalar_one_or_none()
    if not customer:
        raise HTTPException(
            status_code=400,
            detail="Пользователь с таким email или номером телефона не существует"
        )
    return ResponseCustomer.model_validate(customer)


# get customers
async def get_customers(session: AsyncSession) -> list[ResponseCustomer]:
    result = await session.execute(select(Customer))
    customers = result.scalars().all()
    return [ResponseCustomer.model_validate(customer) for customer in customers]
