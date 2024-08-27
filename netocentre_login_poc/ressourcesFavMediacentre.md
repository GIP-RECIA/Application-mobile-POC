# Récuperation des ressources favorites du Mediacentre

- [Récuperation des ressources favorites du Mediacentre](#récuperation-des-ressources-favorites-du-mediacentre)
  - [URI à contacter](#uri-à-contacter)
  - [Exemple dans le Mediacentre-UI](#exemple-dans-le-mediacentre-ui)


## URI à contacter 
1. Récupération du JWT token : 
   ```
   /api/v5-1/userinfo?claims=private,ESCOSIRENCourant,ESCOSIREN,ENTPersonGARIdentifiant,profile&groups=
    ```

> ⚠️ A partir de là, toutes les requetes sont à effectuer avec le JWT token passé en header. Le JWT est à envoyer en tant que Bearer dans l'en-tête Authorization

2. Récupération de la config frontend contenue en backend : 
      ```
   /api/config
    ```

La config est sous la forme  : 
```json
[
  {
    key: "configAttribute1",
    value: "configAttValue1",
  },
    {
    key: "configAttribute2",
    value: "configAttValue2",
  },
  ...
]
```

Ce qui va t'intéresser dans la config est la regex pour les groupes (key="groups").

3. Récupération des groupes : 
  ```
  /api/groups
  ```
Ce que tu vas récupèrer n'est pas directement une liste de groupes, il faudra faire un traitement sur les données [voir exemple](#exemple-dans-le-mediacentre-ui).

4. Récupération des ressources : 
  ```
  /api/resources
  ```

Les ressources seront sous la forme : 
```json
[
  {
    "distributeurTech":"distributeur1",
    "domaineEnseignement":[],
    "idEditeur":"idEditeur1",
    "idRessource":"idRessource1",
    "idEtablissement":[
      {
        "id":"idEtablissement1",
        "UAI":"UAIEtablissement1",
        "nom":"nomEtablissement1"
      }
    ],
    "idType":"type1",
    "niveauEducatif":[
      {
        "nom":"nomNiveauEducatif1",
        "uri":"uriNiveauEducatif1"
      },
      {
        "nom":"nomNiveauEducatif2",
        "uri":"uriNiveauEducatif2"
      },
      {
        "nom":"nomNiveauEducatif3",
        "uri":"uriNiveauEducatif3"
      },
      {
        "nom":"nomNiveauEducatif4",
        "uri":"uriNiveauEducatif4"
      }
    ],
    "nomEditeur":"nomEditeur1",
    "nomRessource":"nomRessource1",
    "sourceEtiquette":"sourceEtiquette1",
    "typePedagogique":[
      {
        "nom":"nomTypePedagogique1",
        "uri":"uriTypePedagogique1"
      },
      {
        "nom":"nomTypePedagogique2",
        "uri":"uriTypePedagogique2"
      },
      {
        "nom":"nomTypePedagogique3",
        "uri":"uriTypePedagogique3"
      }
    ],
    "typePresentation":{
      "code":"codeTypePresentation1",
      "nom":"nomTypePresentation1"
    },
    "typologieDocument":[
      {
        "nom":"nomTypologieDocument1",
        "uri":"uriTypologieDocument1"
      },
      {
        "nom":"nomTypologieDocument2",
        "uri":"uriTypologieDocument2"
      },
      {
        "nom":"nomTypologieDocument3",
        "uri":"uriTypologieDocument3"
      }
    ],
    "urlAccesRessource":"urlAccesRessource1",
    "urlVignette":"urlVignette1",
    "validateurTech":"validateurTech1"
  },
  ...
]
```

5. Récuperation des identifiants des ressources favorites : 
  ```
  /api/prefs/getentityonlyprefs/Mediacentre
  ```
  Tu vas récupérer un Array, il faudra récupérer dedans *mediacentreFavorites* (sensible à la casse).
  
6. Filtrage des ressources en fonction des ids fav récupérés 
  

## Exemple dans le Mediacentre-UI 
```javascript
export type ConfigType = {
  key: string;
  value: string;
};

let config: Array<ConfigType> = [];

const getConfig = async (baseApiUrl: string) => {
  try {

    //récupération de la config 
    const response = await instance.get(`api/config`);
    config = response.data;
  } catch (e: any) {
    if (e.response) {
      throw new CustomError(e.response.data.message, e.response.status);
    } else if (e.code === 'ECONNABORTED') {
      throw new CustomError(e.message, e.code);
    }
  }
};

// baseApiUrl = MediacentreAPIURL 
const getResources = async (baseApiUrl: string, groupsApiUrl: string) => {
  try {

    // 3. récupération des groupes 
    const resp = await instance.get(groupsApiUrl);

    const groupsConfigValue: string = config.find((element) => {
      if (element.key === 'groups') {
        return element;
      }
    })!.value;

    const regexGroups = new RegExp(groupsConfigValue);
    const userGroups = new Array<string>();

    // traitement sur les données pour récupérer uniquement le nom de chaque groupe.
    resp.data.groups.forEach((element: any) => {
      if (regexGroups.test(element.name)) {
        userGroups.push(element.name);
      }
    });

    // récupération des ressources
    const response = await instance.post(baseApiUrl, { isMemberOf: userGroups });
    return response.data;
  } catch (e: any) {
    if (e.response) {
      throw new CustomError(e.response.data.message, e.response.status);
    } else if (e.code === 'ECONNABORTED') {
      throw new CustomError(e.message, e.code);
    }
  }
};
// URI du point 5 décomposée 
const getFavorites = async (getUserFavoriteResourcesUrl: string, fnameMediacentreUi: string) => {
  try {
    const response = await instance.get(`${getUserFavoriteResourcesUrl}${fnameMediacentreUi}`);
    return response.data.mediacentreFavorites;
  } catch (e: any) {
    throw new CustomError(e.response.data.message, e.response.status);
  }
};
```
