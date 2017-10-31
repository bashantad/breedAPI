##### Problem Statement

Our cat folksonomy will be a way to categorize and tag cats. Each "entity" will
be a cat breed, and each "tag" will be a character trait. A basic example of how
this should work is described below:

##### Basic System

```
Entity (cat breed):
  |
  -- Tags (traits)
```

##### Concrete Example

```
American Bobtail
  |
  -- affectionate
  -- low shedding
  -- playful
  -- intelligent

Cymric
  |
  -- affectionate
  -- has no tail
  -- friendly

Norwegian Forest Cat
  |
  -- low shedding
  -- pet friendly
  -- knows kung fu
  -- climbs trees
```

## Tasks / Challenges

### 1. Basic cat breed tagging API

Implement the above folksonomy system as a JSON API in Rails.

#### API route hints

For this first challenge, we've provided some hints for tagging API endpoints.
If you'd like to propose a different architecture for the routes, feel free to
do so with a clear explanation of your reasoning.

##### Breed CRUD

```
POST /breeds

- Breed Name, e.g. 'Norwegian Forest Cat'
- Tags, e.g. ['Knows Kung Fu', 'Climbs Trees']

GET /breeds

- retuns all breeds

GET /breeds/:breed_id

- returns the breed and all the tags belonging to it

PATCH /breeds/:breed_id

- Updates the breed and it's tags (overwrite tags, don't merge)
- Breed Name, e.g. 'Norwegian Forest Cat'
- Tags, e.g. ['Knows Kung Fu', 'Climbs Trees']

DELETE /breeds/:breed_id

- Removes the breed
- When it comes to tags of deleted breeds, please work out a way to ensure there aren't orphaned tags left in the system that can't be deleted.
```

##### Tag CRUD

```
GET /breeds/:id/tags

- Gets tags on a breed

POST /breeds/:id/tags

- Replaces tags on a breed
- Tags, e.g. ['low shedding', 'pet friendly']

GET /tags

- returns all tags in the system

GET /tags/:id

- returns a tag

PATCH /tags/:id

- updates a tag

DELETE /tags/:id

- deletes the tag and all associations to breeds
```

#### Breed & Tag Stats

```
GET /breeds/stats
- Retrieves statistics about all breeds
- breeds: [
    {
      id: 1,
      name: 'American Bobcat',
      tag_count: 4,
      tag_ids: [1, 2, 3, 4]
    },
    {
      id: 2,
      name: 'Cymric',
      tag_count: 3,
      breed_ids: [1, 4, 5]
    }
  ]


GET /tags/stats

- Retrieves statistics about all tags
- tags: [
    {
      id: 1,
      name: 'has no tail',
      breed_count: 1,
      breed_ids: [2]
    },
    {
      id: 2,
      name: 'affectionate',
      breed_count: 2,
      breed_ids: [1, 2]
    }
  ]
```

Considerations:

- the above specification is a guide. If you have ideas that could improve the usability of the API please feel free to adjust the spec and highlight your reasoning in the readme.
- if you're unsure about anything, please ask.
- N+1s are bad

## Improvement needed for prod deployment:

* Proper Authorisation : (API keys, handling of preflight request/response with cors headers)
* Proper logging of the requests/responses
* Proper error handling, At the moment, only record not found is 404, every other error scenario is 500. We can provide more informative message to the user.
* Throttling to limit the number of calls
* Versioning, Caching
* More unit tests(At the moment only controller tests have been written)


