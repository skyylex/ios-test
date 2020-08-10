### Architecture

The architecture is a variation of VIPER (one of the approaches to implement Clean Architecture in iOS). The exact split of modules and interfaces is inspired by https://github.com/rambler-digital-solutions/rambler-it-ios.

**Key classes of the architecture:**

 - **V - View**. Represents actual UI layer which is responsible for showing UI based on the provided data and forwarding interaction events outside.
 - **I - Interactor**. Represents aggregation of business logic, services, data layer.
 - **P - Presenter**. Controls presentation of the View, forwards interaction to Interactor to perform changes in the model or remote service.
 - **E - Entity**. In the traditional approach represents data types of persistent storage (models). Defines what is transfered in application data flow. Data transfer objects (Plain objects) also could be in this category.  
 - **R - Router**. Represents External UX flow (transitions between screens) and requests to external UI. In the provided architecture is also responsible for creation (for simplicity).

**The interaction between layers could be described in the following diagram:**
```
          Router
             |
View <-> Presenter <-> Interactor <-> Services 
```

**Key principles of architecture:**

- Strict separation of the concerns between layers. So you know where to place your code.
- Inputs / Outsputs protocols that define external dependencies. Most of the classes don't know much except provided inputs / outputs. 
- The layers interact only with neighbours. It allows to minimize spread of changes if they are necessary.
- No storyboards - everything is programmed. Takes more time, but simplifies testability a bit and re-usability in long-term.

### Choice of libraries

I've tried to minimize usage of the external libraries. So everything is done with native tools such as Foundation / UIKit / XCTest. 

Reasoning: Everything that was requested in the task was possible to do with native tools with small overhead. For more serious challenges like data storage there is more sense to consider an alternative.

**Advantages:**
- More control of what's used (security, stability).
- Familiarity with the tools

**Disadvantages:**
- More code to write
- More time spent and implementing all required functionality 

### The most difficult part

- From organizational perspective it was .. to stop. Since there was a limit of 8h. With Viper architecture I believe it takes more time to implement everything, but I wanted to show my skills. So it's possible that I exceeded the limit a bit. :)

From technical perspective: using less familiar approach (VIPEW) took more time than I expected and also I needed to refresh some of the skills (UI layer implementation). Day-to-day work usually contains a lot of customized code that you don't use in the test projects :) 

### Percentage of readiness / additional time to finish it

I believe about 60% of work is done. I tried to choose the MVP use cases to make sense as a whole and create a foundation to add more stuff on top later.

The following things are still necessary to do:

- Unit test for Presenter / Interactors / NetworkService: ~ 1-2h
- Additional network requests and its usage: 1-2h
- Data storage layer (offline mode): 2h (with external library / wrapper for CoreData, to simplify setup) 
