# Models

## Entity
An example of an entity is a council.  It could also be a board of some kind. The entity itself is not a meeting body - meeting groups are defined separately.  An entity has a name, members and meeting groups.

*Properties*

- Name:  example - SomeCity Council
- Members: all of the members of the entity and its meeting groups
- Meeting groups: example - the full council could be one meeting group and each of its committees would be separate meeting groups

## Member
Example: Councillor John Smith.

*Properties*

- Title
- First name
- Last name

All members for a given entity are stored as a property of that entity.


## Meeting group
Example: Finance Committee

*Properties*

- Name
- Members

The meeting groups of an entity are stored as a property of the entity.

## Event
Example: a meeting of a committee


## Persistent storage
Model data are stored as UIDocuments.

*Entity document*

- Each entity, including its sub-entities and members, is saved as a document

*Event document*

- Each event is saved as a document

