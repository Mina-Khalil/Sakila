CREATE VIEW Films_View AS
SELECT
    F.filmId,
    F.title,
    F.description,
    F.releaseYear,
    F.languageId AS filmLanguageId,
    F.rentalDuration,
    F.length,
    F.replacementCost,
    F.rating,
    F.rentalRate,
    F.specialFeatures,
    F.lastUpdate AS filmLastUpdate,
    FC.categoryId,
    FC.lastUpdate AS filmCategoryLastUpdate,
    C.name AS categoryName,
    C.lastUpdate AS categoryLastUpdate,
    L.name AS languageName,
    L.languageId AS languageId,
    L.lastUpdate AS languageLastUpdate
FROM
    Film F
JOIN
    filmCategory FC ON F.filmId = FC.filmId
JOIN
    Category C ON FC.categoryId = C.categoryId
JOIN
    Language L ON F.languageId = L.languageId


