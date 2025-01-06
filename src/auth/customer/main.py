from fastapi import APIRouter, Depends, Header, HTTPException
from sqlalchemy import select, or_
from sqlalchemy.ext.asyncio import AsyncSession

from ..jtw_ import create_access_token, decode_jwt
from ...database import get_session
from ...models import Customer
from .crud import login_customer, create_customer, get_current_customer, get_customers
from .schema import LoginSchemaCustomer, RegisterSchemaCustomer, ResponseCustomer, CurrentCustomer

auth_customer = APIRouter()

# login auth customer
@auth_customer.post("/login-customer")
async def login_auth_customer(user_data: LoginSchemaCustomer, session: AsyncSession = Depends(get_session)):
    if user_data.email:
        condition = Customer.email == user_data.email
    elif user_data.phone_number:
        condition = Customer.phone_number == user_data.phone_number
    else:
        raise HTTPException(
            status_code=400,
            detail="Необходимо указать email или номер телефона."
        )

    customer = await login_customer(session=session, user_data=user_data, condition=condition)
    return {"access_token": create_access_token(data=customer.model_dump())}

# register auth customer
@auth_customer.post("/register-customer")
async def register_auth_customer(user_data: RegisterSchemaCustomer, session: AsyncSession = Depends(get_session)):
    customer_exists = await session.execute(
        select(Customer).where(
            or_ (
                Customer.email == user_data.email,
                Customer.phone_number == user_data.phone_number
            )
        )
    )
    if customer_exists.scalar_one_or_none():
        raise HTTPException(
            status_code=400,
            detail="Заказчик с таким email или номером телефона уже существует"
        )

    customer = await create_customer(session=session, user_data=user_data)
    return {"access_token": create_access_token(data=customer.model_dump())}

# current customer
@auth_customer.post("/current-customer")
async def register_current_customer(authorization: str = Header(), session: AsyncSession = Depends(get_session)) -> ResponseCustomer:
    if not authorization.startswith("Bearer "):
        raise HTTPException(
            status_code=400,
            detail="Неверный формат токена. Используйте Bearer токен."
        )

    decode_jwt_token = decode_jwt(token=authorization[7:])
    get_user_data = CurrentCustomer(
        email=decode_jwt_token['email'], 
        phone_number=decode_jwt_token['phone_number']
    )
    current_user_data = await get_current_customer(session=session, user_data=get_user_data)
    return current_user_data

# get customer all
@auth_customer.get("/get-customer-all")
async def get_customer_all(session: AsyncSession = Depends(get_session)) -> list[ResponseCustomer]:
    return await get_customers(session=session)
