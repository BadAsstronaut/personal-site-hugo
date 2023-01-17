---
title: Writing a full REST API using Chat GPT
subtitle: Make your API do more with less time using AI
date: 2023-01-07
---

## Introduction

I, like many others in the tech industry, have found myself on the job hunt. Many technical positions require a code sample/project. There are plenty of reasons to wonder how effectively such projects reflect technical talent, or if such projects require an unfair amount of effort from the applicant... but this is not an article about that. Regardless of personal opinions, these projects provide employers a point-of-reference on a candidate's technical approach. How well documented is the code? Is there a pattern of separation-of-concerns? Does the API meet the requirements of the project?

For one company, I had an option to share a project, do a live coding interview, or work on a take-home project. I chose the take-home project because:

- a new project provides the opportunity highlight my fit for the role
- I wanted to play more with ChatGPT
- I knew I wanted to write this article.

So, here we are. The requirements for the project were pretty straightforward. "Build a functional REST API for CRUD permissions on a joke of the day."

Obviously this could be fulfilled in a _lot_ of ways. How we go about providing a REST API is part of the decision. If I were going for the quick turn-around time, [PostgREST](https://postgrest.org/en/stable/index.html) can spin up a REST API with only a database! A [docker-compose](https://docs.docker.com/compose/) file and a SQL script would deliver the requirement!

I wanted to experiment with using ChatGPT to generate the scaffolding for my API, so I opted for a Python [FastAPI](https://fastapi.tiangolo.com/) implementation.

The resulting implementation is available on [GitHub]([github](https://github.com/BadAsstronaut/jotd).

## Getting started

I plugged my requirements into ChatGPT:

```plaintext
Build a functional REST API to CRUD on a Joke of the Day. (JOTD)

Requirements

    Build the application using your favorite language
    The JOTD has required fields of “text” and “date” and an optional field called “description”
    API request and response should be JSON
```

I was not sure what I expected, but ChatGPT provided a great high-level overview in response:

```plaintext
To build a functional REST API to CRUD on a Joke of the Day (JOTD), you will need to follow these general steps:

    Choose a programming language to build the application. Some popular choices for building REST APIs include Python, Java, and JavaScript.

    Create a JOTD model with the required fields of "text" and "date", and an optional field called "description".

    Implement CRUD endpoints for the JOTD, using standard RESTful conventions (e.g. GET for reading, POST for creating, PUT for updating, and DELETE for deleting).

    Use JSON for the request and response formats for the API.

...
It is important to note that this is a high-level overview of building a REST API, and there will be many details to consider depending on the specific requirements of the project and the programming language you choose.

```

Not super helpful to implementation, though. So, I asked the machine to `joke of the day rest api in python using fastapi`. Here's what we got:

```plaintext
Here is an example of how you could build a Joke of the Day (JOTD) REST API in Python using the FastAPI web framework:

    Install the required packages:

pip install fastapi
pip install pydantic
pip install sqlalchemy
pip install databases

    Create a JOTD model using Pydantic:

from pydantic import BaseModel

class JOTD(BaseModel):
    text: str
    date: str
    description: str = None

    Create a database connection using SQLAlchemy and Databases:

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from databases import Database

DATABASE_URL = "sqlite:///./jotd.db"

engine = create_engine(DATABASE_URL)
Base = declarative_base()

class JOTD(Base):
    __tablename__ = "jotd"
    id = Column(Integer, primary_key=True, index=True)
    text = Column(String, index=True)
    date = Column(String, index=True)
    description = Column(String)

Base.metadata.create_all(bind=engine)

database = Database(DATABASE_URL)

    Define CRUD endpoints using FastAPI:

from fastapi import FastAPI, HTTPException

app = FastAPI()

@app.post("/jotd", response_model=JOTD)
async def create_jotd(jotd: JOTD):
    query = jotd.insert().values(text=jotd.text, date=jotd.date, description=jotd.description)
    jotd_id = await database.execute(query)
    jotd = await get_jotd(jotd_id)
    return jotd

...
```

Now this is useful! There are issues, such as poor organization, some structural assumptions, etc... BUT this is a great way to go from 0 to _something_ very quickly.

I thought there was enough here to get started on the project, so, here we go...

## Implementation

So, to get started, I created a directory and added an empty `README.md` and `requirements.txt`, a `src/` subdirectory, and a Dockerfile. I already had a FastAPI Dockerfile from a different project, which looks like:

```Dockerfile
FROM python:3.10-bullseye

RUN pip install --upgrade pip \
    && apt-get update \
    && apt-get install -y python3-brlapi sqlite3 \
    && adduser --disabled-login --gecos '' api_user

USER api_user
WORKDIR /home/api_user

COPY --chown=api_user:api_user requirements.txt requirements.txt
RUN pip install --user -r requirements.txt
ENV PATH="${PATH}:/home/api_user/.local/bin"

COPY --chown=api_user:api_user src .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0"]

```

Note that this Dockerfile provisions an `api_user` so that the API does not run as root. Out of curiosity, I submitted the Dockerfile to ChatGPT3, and here's what we get:

```plaintext
This is a Dockerfile that can be used to create a containerized version of a Python application. The image is based on the Bullseye version of Python 3.10, and it starts by installing the necessary dependencies such as pip and sqlite3. It then creates a new user called api_user, and sets the working directory to the home directory of the new user. Next it copies the requirements.txt file and installs the dependencies in the container.
It then copies the source code of the application in the container and sets the command to run the application using uvicorn, which is a production-ready ASGI server, and specifies the host to be 0.0.0.0 so that the application can be accessed from outside the container.
```

![LGTM Rambo](https://img.memegenerator.net/instances/68447791.jpg)

## Collaborating with the Robot

I asked ChatGPT to `generate a README for the jotd API.` Here's the response (formatting removed for convenience).

```plaintext
Joke of the Day (JOTD) REST API

This is a simple REST API for managing Jokes of the Day (JOTD) built using Python, FastAPI, SQLAlchemy and Databases.
Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.
Prerequisites

    Python 3.8 or later
    Pipenv

Installing

    Clone the repository

git clone https://github.com/your-username/jotd-api.git

    Install the dependencies

pipenv install

    Run the migrations

pipenv run alembic upgrade head

    Run the development server

pipenv run uvicorn main:app --reload

The API will be available at http://localhost:8000/.
Endpoints

    POST /jotd: Create a new JOTD
    GET /jotd/{id}: Retrieve a specific JOTD by ID
    PUT /jotd/{id}: Update a specific JOTD by ID
    DELETE /jotd/{id}: Delete a specific JOTD by ID
    GET /jotd: Retrieve a list of all JOTDs

Built With

    FastAPI - The web framework used
    SQLAlchemy - Object-Relational Mapper
    Databases - Async ORM

Authors

    Your name - *Initial
```

Nice job robot!

![Robot fistbump](data:image/jpeg;base64,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)

Obviously this will need to be edited and updated, but look how much value we get out of having some basic README elements populated.

Now that I have a README drafted, a Dockerfile in place, and some requirements in my `requirements.txt`, it's time to ask for some more code!

## Iteration with my AI partner

I knew we wanted CRUD endpoints, so I asked ChatGPT to `generate FastAPI CRUD endpoints for jotd`. Here's what we got...

```python
from fastapi import FastAPI, HTTPException
from sqlalchemy.orm import Session

app = FastAPI()

@app.post("/jotd", response_model=JOTD)
def create_jotd(jotd: JOTD, db: Session = Depends(get_db)):
    db.add(jotd)
    db.commit()
    db.refresh(jotd)
    return jotd

@app.get("/jotd/{id}", response_model=JOTD)
def read_jotd(id: int, db: Session = Depends(get_db)):
    jotd = db.query(JOTD).filter(JOTD.id == id).first()
    if jotd is None:
        raise HTTPException(status_code=404, detail="JOTD not found")
    return jotd

```

Obviously, the imports won't work but that's ok. We can wire those in. I am more concerned with having the API endpoints hitting the `db` object directly. So, I told ChatGPT that I wanted to `refactor jotd to follow repository layer conventions`.

Here's what we got:

```python
from typing import List

class JOTDRepository:
    def __init__(self, db: Session):
        self.db = db

    def get(self, id: int) -> JOTD:
        return self.db.query(JOTD).filter(JOTD.id == id).first()

    def get_all(self) -> List[JOTD]:
        return self.db.query(JOTD).all()

    def create(self, jotd: JOTD) -> JOTD:
        self.db.add(jotd)
        self.db.commit()
        self.db.refresh(jotd)
        return jotd

    def update(self, jotd: JOTD) -> JOTD:
        self.db.merge(jotd)
        self.db.commit()
        self.db.refresh(jotd)
        return jotd

    def delete(self, jotd: JOTD):
        self.db.delete(jotd)
        self.db.commit()

@app.post("/jotd", response_model=JOTD)
def create_jotd(jotd: JOTD, db: Session = Depends(get_db)):
    repository = JOTDRepository(db)
    return repository.create(jotd)

@app.get("/jotd/{id}", response_model=JOTD)
def read_jotd(id: int, db: Session = Depends(get_db)):
    repository = JOTDRepository(db)
    jotd = repository.get(id)
    if jotd is None:
        raise HTTPException(status_code=404, detail="JOTD not found")
    return jotd

@app.put("/jotd/{id}", response_model=JOTD)
def update_jotd(id: int, jotd: JOTD, db: Session = Depends(get_db)):
    repository = JOTDRepository(db)
    stored_jotd = repository.get(id)
    if stored_jotd is None:
        raise HTTPException(status_code=404, detail="JOTD not found")
    stored_jotd.text = jotd.text
    stored_jotd.date = jotd.date
    stored_jotd.description = jotd.description
    return repository.update(stored_jotd)

@app.delete("/jotd/{id}", response
```

Clearly we wouldn't want the repository in the same file as the routes, but this was actually... helpful.

## Learning assistant

I don't tend to rely heavily on ORMs; and I tend to use language primatives for data validation. That said, my goal here is to leverage ChatGPT to write an API. So, based on this, I decided to refresh my memory on [SQLAlchemy](https://sqlalchemy.org). I asked `What does sqlalchemy declarative_base do?`.

```plaintext
sqlalchemy.ext.declarative.declarative_base() is a function provided by the SQLAlchemy ORM (Object-Relational Mapper) library that creates a base class for declarative models. This base class is then used as a factory for new model classes.

The declarative system allows you to define your database tables and their columns using Python classes, rather than writing raw SQL statements. This makes it easier to maintain and reason about your database schema, and allows for a more pythonic and object-oriented approach to working with databases.

When you create a new class that inherits from the base class returned by declarative_base(), that class will be automatically mapped to a database table, and its attributes will be mapped to columns in that table.

For example, you can define a JOTD model like this:

from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class JOTD(Base):
    __tablename__ = "jotd"
    id = Column(Integer, primary_key=True, index=True)
    text = Column(String, index=True)
    date = Column(String, index=True)
    description = Column(String, index=True)

This JOTD class will be mapped to a table named jotd in your database and its attributes will be mapped to columns.

When you create an instance of this class and add it to a session, SQLAlchemy will automatically create the corresponding rows in the database table, and when you query the table, SQLAlchemy will automatically create instances of the class and populate them with the data from the rows in the table.

The declarative_base() also allows you to create a single place to define common columns like created_at and updated_at which will be shared across all models.
```

The #1 rule when working with AI: Trust but verify. Hitting the [docs](https://docs.sqlalchemy.org/en/13/orm/extensions/declarative/api.html#sqlalchemy.ext.declarative.declarative_base) took a little longer to get to the same summary generated by ChatGPT. Thanks, robo pal!

## Wiring it together and fixing the style

From my jaunt into the `sqlalchemy` docs, I knew I wanted to use a [sessionmaker](https://docs.sqlalchemy.org/en/13/orm/session_api.html?highlight=sessionmaker#sqlalchemy.orm.session.sessionmaker). I told ChatGPT to update the repository it created to `add a sessionmaker to the CRUD repository layer:

```python
'''Here is an example of how you can create a CRUD repository module using a SessionMaker in SQLAlchemy:'''

from sqlalchemy.orm import Session
from sqlalchemy.orm import sessionmaker

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

class JOTDRepository:
    def __init__(self):
        self.session:Session
    def __enter__(self):
        self.session = SessionLocal()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.session.close()
    def get(self, id: int) -> JOTD:
        return self.session.query(JOTD).filter(JOTD.id == id).first()

    def get_all(self) -> List[JOTD]:
        return self.session.query(JOTD).all()

    def create(self, jotd: JOTD) -> JOTD:
        self.session.add(jotd)
        self.session.commit()
        self.session.refresh(jotd)
        return jotd

    def update(self, jotd: JOTD) -> JOTD:
        self.session.merge(jotd)
        self.session.commit()
        self.session.refresh(jotd)
        return jotd

    def delete(self, jotd: JOTD):
        self.session.delete(jotd)
        self.session.commit()
```

COOL! That will do us for now, so let's think about our models: `make a model for jotd that uses the repository`. As expected at this point, ChatGPT generated a reasonable class-based model. I prefer a more [functional style](https://docs.python.org/3/howto/functional.html). So, I asked it: `use a functional python style to make a model using the repository`. I was bowled over when this actually worked!

## Getting the AI to call my code

From here, I spent a little time making a `db.py` file for the respository. The elements it needed had already been provided by ChatGPT in the context of the repo module, so after I had it hashed out I showed ChatGPT my `db.py` module.

```plaintext
here's a python db.py file
'''
Creates databases and connection object
'''

import os

from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import declarative_base, sessionmaker

database_url = os.getenv('DATABASE_URL', 'sqlite:///jotd.db')

engine = create_engine(database_url)
Base = declarative_base()


class JOTD(Base):
    ''' Joke of the day DB table '''
    __tablename__ = 'jotd'
    id = Column(Integer, primary_key=True, index=True)
    text = Column(String)
    date = Column(String, index=True)
    description = Column(String)


Base.metadata.create_all(engine)

Session = sessionmaker(bind=engine)
```

From this input, ChatGPT provided the following description:

```plaintext
This is a Python module that creates a database connection and a JOTD model using SQLAlchemy, an ORM (Object-Relational Mapper) library for Python.

It starts by importing the necessary modules from SQLAlchemy, including the create_engine, Column, Integer, String and declarative_base modules.

Then it sets the database_url variable to either the value of the DATABASE_URL environment variable or a default SQLite URL. This allows the application to be run locally using SQLite or on a remote server using any other database.

The engine variable is then created using the create_engine method, which takes the database_url as a parameter.

A Base variable is defined using the declarative_base method provided by SQLAlchemy. This Base variable will be used as a factory for new model classes.

The JOTD class is defined, which inherits from the Base variable. It has 4 attributes, id, text, date, description which will be mapped to columns in the jotd table when the table is created.

The Base.metadata.create_all(engine) method creates all the tables defined in the model classes that inherit from Base.

Finally, a Session variable is defined using the sessionmaker function provided by SQLAlchemy. This variable is bound to the engine variable and will be used to create a new session for each request.
```

I _literally_ could not have said it better myself. Now that ChatGPT "knows" about my `db.py` file, I instructed it: `using a functional python style, create a jotd.py repository file that uses db.py`.

Here's the output:

```python
from typing import Tuple, List

from db import Session, JOTD

def create_jotd(text: str, date: str, description: str) -> Tuple[JOTD, int]:
    session = Session()
    jotd = JOTD(text=text, date=date, description=description)
    session.add(jotd)
    session.commit()
    session.refresh(jotd)
    session.close()
    return jotd, HTTP_CREATED
```

CANCEL! We want to use `with` syntax! So we tell the robot: `using a functional python style, create a jotd.py repository file that uses db.py with Session() as session`

```python
'''
Here is an example of how you can use a functional programming style to create a JOTD repository using the JOTD model defined in db.py, with session management:
'''

from typing import Tuple, List

from db import Session, JOTD

def create_jotd(text: str, date: str, description: str) -> Tuple[JOTD, int]:
    with Session() as session:
        jotd = JOTD(text=text, date=date, description=description)
        session.add(jotd)
        session.commit()
        session.refresh(jotd)
    return jotd, HTTP_CREATED

def read_jotd(jotd_id: int) -> Tuple[JOTD, int]:
    with Session() as session:
        jotd = session.query(JOTD).filter(JOTD.id == jotd_id).first()
        if jotd is None:
            return None, HTTP_NOT_FOUND
    return jotd, HTTP_OK

def update_jotd(jotd_id: int, text: str, date: str, description: str) -> Tuple[JOTD, int]:
    with Session() as session:
        jotd = session.query(JOTD).filter(JOTD.id == jotd_id).first()
        if jotd is None:
            return None, HTTP_NOT_FOUND
        jotd.text = text
        jotd.date = date
        jotd.description = description
        session.commit()
    return jotd, HTTP_OK

def delete_jotd(jotd_id: int) -> Tuple[JOTD, int]:
    with Session() as session:
        jotd = session.query(JOTD).filter(JOTD.id == jotd_id).first()
        if jotd is None:
            return None, HTTP_NOT_FOUND
        session.delete(jotd)
        session.commit()
    return jotd, HTTP_OK

'''
This JOTD repository defines the CRUD(Create, Read, Update and Delete) operations for JOTD model and uses the Session object from db.py in a functional way. It opens and closes a new session for each request within the context of with Session() as session: and session.close() respectively.

It also returns HTTP status codes along with the results of operations, which can be useful for handling errors and responses in your application.
'''
```

Well, that will do! But since this is a joke of the **DAY**, we need to get the joke by date! I asked ChatGPT `update read_jotd to get the jotd by date`; it had no difficulties:

```python
def read_jotd_by_date(date: str) -> Tuple[JOTD, int]:
    with Session() as session:
        jotd = session.query(JOTD).filter(JOTD.date == date).first()
        if jotd is None:
            return None, HTTP_NOT_FOUND
    return jotd, HTTP_OK
```

## Generating its own references

I decided to follow its recommended convention of using HTTP codes across layers. This isn't my -generated code.

I asked ChatGPT to `create a globals.py file that hydrates the HTTP codes`. It gave me:

```python
'''Here is an example of how you can create a globals.py file that defines the HTTP status codes as global constants:'''

HTTP_OK = 200
HTTP_CREATED = 201
HTTP_NO_CONTENT = 204
HTTP_BAD_REQUEST = 400
HTTP_UNAUTHORIZED = 401
HTTP_FORBIDDEN = 403
HTTP_NOT_FOUND = 404
HTTP_INTERNAL_SERVER_ERROR = 500

'''
You can use these constants in your application to set the HTTP status code of the response. For example, in the create_jotd function of the JOTD repository, you can return jotd, HTTP_CREATED to indicate that the JOTD was successfully created.
You can also add other HTTP status codes that you may need in your application to this file.
It's important to note that this file should be imported and used in all the modules of your application that need to use the HTTP status codes.
'''
```

## Adding exception handling

Since there is so little business logic, we're going to skip a discussion on the `models` for this project. I observed that we were lacking error handling on the `repository` layer. To redress this, without adding a lot of code, we can use a Python [decorator](https://peps.python.org/pep-0318/). To fast-track the process, I asked ChatGPT: `decorator to wrap exception handler for internal server errors`.

```python
'''
Here's an example of a Python decorator that can be used to wrap a function and handle internal server errors (HTTP status code 500) that may occur within that function:
'''

from typing import Callable
from fastapi import HTTPException

def handle_exceptions(func: Callable) -> Callable:
    async def wrapper(*args, **kwargs):
        try:
            return await func(*args, **kwargs)
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))
    return wrapper

You can then use this decorator to wrap the functions that you want to handle the exception for

@handle_exceptions
async def create_jotd(jotd: JOTDCreate):
    jotd, code = await create_jotd(jotd.text, jotd.date, jotd.description)
    return jotd.id if jotd is not None else None, code

'''
This will catch any exception that occurs in the create_jotd function, and raise a new HTTPException with a status code of 500 and the error message as the detail.
It's also good practice to log the exception message for debugging purposes.
You can use python built-in logging module to log the exception and its traceback.
'''
```

Of course, AI has its limitations. My implementation ended up looking like:

```python
def internal_err_handler(func):
    '''
    Decorator that handles uncaught errors and returns None and an error code.
    '''
    @wraps(func)
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except Exception as ex:
            logging.exception(ex)
            return None, globals.HTTP_INTERNAL_SERVER_ERROR
    return wrapper
```

[FuncTools wraps](https://docs.python.org/3/library/functools.html#functools.wraps) ensures the name of the function remains referenced by the original function name. Compared to the original implementation, I was suprised the wrapper function did not reference the `HTTP_INTERNAL_SERVER_ERROR` constant.

## Regenerating the routes

Given all the iteration and updates to the repository and models, I thought it would be cool to feed the code back into GPT and have it regenerate the FastAPI routes. After feeding in my model file, ChatGPT replied:

```plaintext
This models.py file defines functions that act as a layer between the API and the repository module, which handles the interactions with the database.

The functions in this file take input in the form of plain Python objects (e.g. JOTDInput) and use the repository functions to perform CRUD operations on the Joke of the Day data.

For example, the create_jotd() function takes a JOTDInput object as input, and passes its properties (text, date, description) to the create_jotd() function in the repository module to create a new Joke of the Day
```

After this, I wrote: `Create a fast API controller that implementes the jotd models`

Reply:

```python
'''
Here is an example of how you could create a FastAPI controller that implements the JOTD models:
'''

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from models import JOTD, create_jotd, get_jotd_by_id, get_jotd_by_date, update_jotd, delete_jotd

app = FastAPI()

class JOTDInput(BaseModel):
    text: str
    date: str
    description: str = None

@app.post("/jotd/create")
async def create_joke(jotd: JOTDInput):
    new_jotd, code = create_jotd(jotd)
    if code != 201:
        raise HTTPException(status_code=code)
    return {"jotd": new_jotd}

@app.get("/jotd/{jotd_id}")
async def read_joke(jotd_id: int):
    jotd, code = get_jotd_by_id(jotd_id)
    if code != 200:
        raise HTTPException(status_code=code)
    return {"jotd": jotd}

@app.get("/jotd/date/{date}")
async def read_joke_date(date: str):
    jotd, code = get_jotd_by_date(date)
    if code != 200:
        raise HTTPException(status_code=code)
    return {"jotd": jotd}

@app.put("/jotd/{jotd_id}")
async def update_joke(jotd_id: int, jotd: JOTDInput):
    updated_jotd, code = update_jotd(jotd_id, jotd)
    if code != 200:
        raise HTTPException(status_code=code)
    return {"jotd": updated_jotd}

@app.delete("/jotd/{jotd_id}")
async def delete_joke(jotd_id: int):
    _, code = delete_jotd(jotd_id)
    if code != 200:
        raise HTTPException(status_code=code)
    return {"message": "jotd deleted"}

'''
This example defines a FastAPI app and creates several endpoints, each of which corresponds to a CRUD operation for the Joke of the Day data. These endpoints use the functions from the models module to perform the corresponding operations on the Joke of the Day data. The JOTDInput class is used to define the request payloads for the create and update endpoints.
'''
```

I ended up making a lot of iterations and updates from here, and you can see the final product on [github](https://github.com/BadAsstronaut/jotd).

## Final thoughts and conclusions

This differs from my usual approach to building software. For simple CRUD/POC apps, I tend to minimize dependencies. I probably would have implemented [sqlite](https://docs.python.org/3/library/sqlite3.html?highlight=sqlite#module-sqlite3) and passed around dictionaries. The object of these assignments is to assess the efficiency of an engineer, as well as style. I like necessary-and-sufficient dependency management, etc. By implementing the AI-generated code, I feel like I was able to deliver a more feature-complete solution than I would have been able to with my usual approach.
