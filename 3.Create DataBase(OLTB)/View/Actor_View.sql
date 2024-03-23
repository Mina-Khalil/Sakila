
CREATE VIEW Actor_View AS
SELECT
    A.actorId,
    A.firstName,
    A.lastName,
    A.lastUpdate AS actorLastUpdate,
    FA.filmId,
    FA.lastUpdate AS filmActorLastUpdate
FROM
    Actor A
JOIN
    filmActor FA ON A.actorId = FA.actorId