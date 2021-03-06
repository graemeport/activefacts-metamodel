vocabulary Metamodel;

/*
 * Value Types
 */
Adjective is written as String(64);
Agent Name is written as String;
Aggregate Code is written as String(32);
Annotation is written as String;
Assimilation is written as String restricted to {'absorbed', 'partitioned', 'separate'};
Context Note Kind is written as String restricted to {'as_opposed_to', 'because', 'so_that', 'to_avoid'};
Date is written as Date;
Denominator is written as Unsigned Integer(32);
Description is written as String;
Display Role Names Setting is written as String restricted to {'false', 'true'};
Enforcement Code is written as String(16);
Ephemera URL is written as String;
Exponent is written as Signed Integer(16);
Frequency is written as Unsigned Integer(32);
Guid is written as Guid auto-assigned at assert;
Implication Rule Name is written as String;
Length is written as Unsigned Integer(32);
Literal is written as String;
Name is written as String(64);
Nesting Mode is written as String restricted to {'Array', 'Bag', 'Map', 'Repetition'};
Numerator is written as Decimal;
Offset is written as Decimal;
Ordinal is written as Unsigned Integer(16);
Pronoun is written as String(20) restricted to {'feminine', 'masculine', 'neuter', 'personal'};
Regular Expression is written as String;
Ring Type is written as String;
Rotation Setting is written as String restricted to {'left', 'right'};
Scale is written as Unsigned Integer(32);
Subscript is written as Unsigned Integer(16);
Text is written as String(256);
Transaction Phase is written as String restricted to {'assert', 'commit'};
X is written as Signed Integer(32);
Y is written as Signed Integer(32);

/*
 * Entity Types
 */
Agent is identified by its Name;

Aggregate is identified by its Code;

Alternative Set is identified by Guid where
	Alternative Set has one Guid,
	Guid is of at most one Alternative Set;
Alternative Set members are exclusive;

Coefficient is identified by Numerator and Denominator and Coefficient is precise where
	Coefficient has one Numerator,
	Coefficient has one Denominator,
	Coefficient is precise;

Concept is identified by Guid where
	Concept has one Guid,
	Guid is of at most one Concept;
Concept has at most one informal-Description;

Concept Annotation is where
	Concept has mapping-Annotation,
	Annotation applies to Concept;

Constraint [separate] is identified by Concept where
	Constraint is an instance of one Concept;
Name is of Constraint,
	Constraint is called at most one Name;

Context Note is identified by Concept where
	Context Note is an instance of one Concept;
Context Note has one Context Note Kind,
	Context Note Kind is of Context Note;
Context Note has one Description,
	Description is for Context Note;
Context Note applies to at most one relevant-Concept,
	Concept has Context Note;

Enforcement is identified by Constraint where
	Constraint requires at most one Enforcement,
	Enforcement applies to one Constraint;
Enforcement notifies at most one Agent;
Enforcement has one Enforcement Code,
	Enforcement Code is of Enforcement;

Fact is identified by Concept where
	Fact is an instance of one Concept;

Fact Type is independent identified by Concept where
	Fact Type is an instance of one Concept;
Fact is of one Fact Type;

Implication Rule is identified by its Name;
Concept is implied by at most one Implication Rule;

Instance is identified by Concept where
	Instance is an instance of one Concept;
Instance objectifies at most one Fact,
	Fact is objectified as at most one Instance;

Link Fact Type is a kind of Fact Type;

Location is identified by X and Y where
	Location is at one X,
	Location is at one Y;

Presence Constraint is a kind of Constraint;
Presence Constraint has at most one max-Frequency restricted to {1..};
Presence Constraint has at most one min-Frequency restricted to {2..};
Presence Constraint is mandatory;
Presence Constraint is preferred identifier;

Query is identified by Concept where
	Query is an instance of one Concept;
Query projects at most one derived- Fact Type,
	derived- Fact Type is projected from at most one Query;

Reading is identified by Fact Type and Ordinal where
	Fact Type has Reading,
	Reading is for one Fact Type,
	Reading is in one Ordinal position,
	Ordinal reading for fact type is Reading;
Reading has one Text;
Reading is negative;

Ring Constraint is a kind of Constraint;
Ring Constraint is of one Ring Type;

Role is identified by Fact Type and Ordinal where
	Role belongs to one Fact Type,
	Fact Type contains Role,
	Role fills one Ordinal,
	Ordinal applies to Role;

Link Fact Type has one implying-Role,
	implying-Role implies at most one Link Fact Type;
Ring Constraint has at most one other-Role,
	other-Role is of Ring Constraint;
Role is an instance of one Concept;
Role is of Ring Constraint;  // Avoid ambiguity; this is a new fact type
Role is of Ring Constraint,
	Ring Constraint has at most one Role;
Role has at most one role-Name,
	role-Name is name of at least one Role;

Role Sequence is identified by Guid where
	Role Sequence has one Guid,
	Guid is of at most one Role Sequence;
Presence Constraint covers one Role Sequence;
Reading is in one Role Sequence,
	Role Sequence is for Reading;
Role Sequence has unused dependency to force table in norma;

Role Value is identified by Fact and Role where
	Role Value fulfils one Fact,
	Fact includes at least one Role Value,
	Role Value is of one Role;
Instance plays Role Value,
	Role Value is of one Instance;

Set Constraint is a kind of Constraint;

Step is identified by Guid where
	Step has one Guid,
	Guid is of at most one Step;
Step falls under at most one Alternative Set,
	Alternative Set covers at least one Step;
Step specifies one Fact Type,
	Fact Type directs Step;
Step is disallowed;
Step is optional;

Subset Constraint is a kind of Set Constraint;
Subset Constraint covers one subset-Role Sequence;
Subset Constraint covers one superset-Role Sequence;

Topic is identified by topic-Name where
	Topic has one topic-Name,
	topic-Name is of at most one Topic;
Concept belongs to at most one Topic,
	Topic contains Concept;

Import is where
    Topic imports precursor- Topic;

Unit is identified by Concept where
	Unit is an instance of one Concept;
Ephemera URL provides Unit coefficient,
	Unit uses coefficient from at most one Ephemera URL;
Name is of at most one Unit,
	Unit is called one Name;
Unit has at most one Coefficient;
Unit has at most one Offset;
Unit (as Plural Named Unit) has plural-Name;  // Avoid ambiguity; this is a new fact type
Unit (as Plural Named Unit) has at most one plural-Name,
	plural-Name is of at most one Plural Named Unit;
Unit is fundamental;

Value is identified by Literal and Value is literal string and Unit where
	Value is represented by one Literal,
	Literal represents Value,
	Value is literal string,
	Value is in at most one Unit,
	Unit is of Value;
Instance has at most one Value;

Value Constraint is a kind of Constraint;
Role has at most one role-Value Constraint,
	Value Constraint applies to at most one Role;
Value Constraint requires matching at most one Regular Expression;

Variable is identified by Query and Ordinal where
	Query includes at least one Variable,
	Variable is in one Query,
	Variable has one Ordinal position;
Variable projects at most one Role (as Projection),
	Projection is projected from at most one Variable;
Variable (as Objectification Variable) matches nesting over at most one Step,
	Step nests as at most one Objectification Variable;
Variable has at most one Subscript,
	Subscript is of Variable;
Variable is bound to at most one Value;
Variable has at most one role-Name,
	Name is of Variable;

Vocabulary is identified by Name where
	Vocabulary is called one Name;
Vocabulary contains Constraint,
	Constraint belongs to at most one Vocabulary;
Vocabulary includes Unit,
	Unit is in one Vocabulary;

Aggregation is where
	Variable is bound to Aggregate over aggregated-Variable,
	Aggregate of aggregated-Variable is bound as one Variable;

Agreement is identified by Context Note where
	Context Note was added by at most one Agreement,
	Agreement covers one Context Note;
Agreement was on at most one Date,
	Date is of Agreement;

Bound is identified by Value and Bound is inclusive where
	Bound has one Value,
	Value is of at least one Bound,
	Bound is inclusive;

Context According To is where
	Context Note is according to Agent,
	Agent claims Context Note;
Context According To was lodged on at most one Date;

Context Agreed By is where
	Agreement was reached by Agent,
	Agent agreed on Agreement;

Derivation is where
	Unit (as Derived Unit) is derived from base-Unit (as Base Unit) [acyclic, intransitive];
Derivation has at most one Exponent;

Mirror Role is a kind of Role;
Mirror Role is for at most one Role (as Base Role),
	Base Role implies at most one Mirror Role;

Object Type is identified by Vocabulary and Name where
	Object Type belongs to one Vocabulary,
	Object Type is called one Name;
Instance is of one Object Type;
Object Type is an instance of one Concept;
Object Type uses at most one Pronoun;
Object Type plays Role,
	Role is played by one Object Type;
Variable is for one Object Type,
	Object Type is referenced in Variable;

Play is where
	Variable is restricted by Role of Step,
	Step contains Role restricting one Variable;
Play is input;

Population is identified by Vocabulary and Name where
	Vocabulary includes Population,
	Population belongs to at most one Vocabulary,
	Population has one Name,
	Name is of Population;
Population is an instance of one Concept;
Population includes Fact,
	Fact belongs to one Population;
Population includes Instance,
	Instance belongs to one Population;
Population includes Role Value,
	Role Value belongs to one Population;

Role Ref is where
	Role Sequence in Ordinal position includes one Role,
	Role is in Role Sequence in one Ordinal place,
	Role Sequence includes Role in Ordinal place,
	Role has Ordinal place in Role Sequence;
Play projects at most one Role Ref,
	Role Ref is projected from at most one Play;
Role Ref has at most one leading-Adjective;
Role Ref has at most one trailing-Adjective;

Set Comparison Constraint is a kind of Set Constraint;

Set Comparison Roles is where
	Set Comparison Constraint has in Ordinal position one Role Sequence,
	Role Sequence is Ordinal in Set Comparison Constraint,
	in Ordinal position Set Comparison Constraint has Role Sequence,
	Set Comparison Constraint has Role Sequence in one Ordinal position;

Set Equality Constraint is a kind of Set Comparison Constraint;

Set Exclusion Constraint is a kind of Set Comparison Constraint;
Set Exclusion Constraint is mandatory;

Value Range is identified by minimum-Bound and maximum-Bound where
	Value Range has at most one minimum-Bound,
	Value Range has at most one maximum-Bound;

Allowed Range is where
	Value Constraint allows Value Range;

Domain Object Type is a kind of Object Type;
Domain Object Type is independent;

Entity Type is a kind of Domain Object Type;
Entity Type objectifies at most one Fact Type,
	Fact Type is objectified as at most one Entity Type;
Entity Type implicitly objectifies at most one implicitly- objectified Fact Type;

Type Inheritance is a kind of Fact Type identified by Subtype and Supertype where
	Entity Type (as Subtype) is subtype of super-Entity Type (as Supertype) [acyclic, intransitive],
	Supertype is supertype of Subtype;
Assimilation applies to Type Inheritance,
	Type Inheritance uses at most one Assimilation;
Type Inheritance provides identification;

Value Type is a kind of Domain Object Type;
Value is of one Value Type,
	Value Type has Value;
Value Type has at most one Length,
	Length is of Value Type;
Value Type has at most one Scale,
	Scale is of Value Type;
Value Type is auto-assigned at at most one Transaction Phase;
Value Type is of at most one Unit;
Value Type has at most one Value Constraint,
	Value Constraint constrains at most one Value Type;
Value Type is subtype of at most one super-Value Type (as Supertype) [acyclic, transitive],
	Supertype is supertype of Value Type;

Value Type Parameter is where
	Value Type has parameter called Name,
	Name identifies parameter of Value Type;
Value Type Parameter requires value of one parameter-Value Type;

Value Type Parameter Restriction is where
	Value Type receives Value Type Parameter,
	Value Type Parameter applies to Value Type;
Value Type Parameter Restriction has one Value;

/* Compositions */
Composition is identified by Guid where
	Composition has one Guid,
	Guid is of at most one Composition;
Composition is called one Name,
	Name is of at most one Composition;

Component is identified by Guid where
	Component has one Guid,
	Guid is of at most one Component;
Component (as Member) belongs to at most one Component (as Parent) [acyclic, stronglyintransitive],
	Parent contains Member;
Component projects at most one Name;
Component has at most one Ordinal rank;
Component has absolute name;

Indicator is a kind of Component;
Indicator indicates one Role played;
Indicator uses at most one false-Value;
Indicator uses at most one true-Value;

Discriminator is a kind of Component;
Discriminated Role is where
	Discriminator distinguishes Role using one Value,
	Role is indicated by Value for Discriminator;

Mapping is a kind of Component;
Mapping represents one Object Type;
Mapping uses at most one native- type Name;

Composite is identified by Mapping where
	Mapping projects at most one Composite,
	Composite consists of one Mapping;
Composition contains Composite,
	Composite belongs to one Composition;

Temporal Mapping is a kind of Mapping;
Temporal Mapping records time using one Value Type;

Absorption is a kind of Mapping;
Absorption traverses to one child-Role;
Absorption traverses from one parent-Role;
forward-Absorption is matched by at most one reverse-Absorption,
	reverse-Absorption is reverse of at most one forward-Absorption;
Absorption flattens;

/*
some Absorption traverses from some parent- Role(1) and that Role(1) is played by some Object Type
	only if that Absorption is a kind of Component(2) that contains some Component(3) that is a Mapping that represents that Object Type;
*/
some Absorption traverses to some child- Role(1) and that Role(1) is played by some Object Type
	only if that Absorption is a kind of Mapping that represents that Object Type;

Full Absorption is where
	Composition fully absorbs Object Type;
Full Absorption applies to one Absorption,
	Absorption creates at most one Full Absorption;
/*
some Object Type is involved in some Full Absorption that applies to some Absorption that is a kind of Mapping
	if and only if
	that Mapping represents that Object Type;
*/

/*
 * Composition constraint categories
 */
Leaf Constraint is where
	Component has leaf-Constraint,
	Constraint applies to Component;

Local Constraint is where
	Composite contains local-Constraint,
	local-Constraint connects leaves of Composite;

Spanning Constraint is where
	Composite has spanning-Constraint,
	Constraint spans Composite;

Scoping is a kind of Mapping;
Injection is a kind of Mapping;
Value Field is a kind of Injection;
Surrogate Key is a kind of Injection;
Valid From is a kind of Injection;

/* Access Paths */
Access Path is identified by Guid where
	Access Path has one Guid,
	Guid is of at most one Access Path;
Access Path is called at most one Name;
Access Path is to one Composite,
	Composite is reached through Access Path;

/* Indices */
Index is a kind of Access Path;
Index is unique;
Index derives from one Presence Constraint;
Composite has at most one natural-Index,
	Index is natural for at most one Composite;
Composite has primary-Index;  // Avoid ambiguity; this is a new fact type
Composite has at most one primary-Index,
	Index is primary for at most one Composite;
Index is primary for Composite
	only if Index is unique;
Composite has primary Index
	only if Composite is reached through Access Path that is an Index;

Index Field is where
	Access Path for Ordinal field uses one Component,
	Component provides Ordinal field for Access Path;
Index Field is discriminated by at most one Value;
each Access Path occurs at least one time in
	Access Path for Ordinal field uses Component;

/* Foreign keys */
Foreign Key is a kind of Access Path;
either Access Path is an Index or Access Path is a Foreign Key but not both;
Foreign Key traverses from one source-Composite,
	Composite contains Foreign Key;
Foreign Key derives from one Absorption,
        Absorption gives rise to at most one Foreign Key;

Foreign Key Field is where
	Foreign Key for Ordinal field uses one Component,
	Component provides Ordinal field for Foreign Key;
each Foreign Key occurs at least one time in
	Foreign Key for Ordinal field uses Component;
Foreign Key Field is discriminated by at most one Value;

/* Nesting is a non-first-normal form used for SQL ARRAY and Map (hstore) fields */
Nesting is where
	Absorption is nested under index-Role in Ordinal position,
	Absorption in Ordinal position is nested under one Role,
	Role keys nesting of Absorption at Ordinal priority;
Absorption uses at most one Nesting Mode;
Nesting has at most one key-Name;
Absorption is nested under index Role in Ordinal position
	if and only if
	that Absorption uses some Nesting Mode;

/*
 * Diagrams
 */
Diagram is identified by Vocabulary and Name where
	Diagram is for one Vocabulary,
	Vocabulary contains Diagram,
	Diagram is called one Name,
	Name is of Diagram;
ORM Diagram is a kind of Diagram;

Shape is identified by Guid where
	Shape has one Guid,
	Guid is of at most one Shape;
Shape is in one ORM Diagram,
	ORM Diagram includes Shape;
Shape is at at most one Location;

each combination ORM Diagram, Location occurs at most one time in
	Shape is in ORM Diagram,
	Shape is at Location;

Fact Type Shape is a kind of Shape;
Fact Type Shape has at most one Display Role Names Setting;
Fact Type Shape is for one Fact Type,
	Fact Type has Fact Type Shape;
Fact Type Shape has at most one Rotation Setting;

Object Type Shape is a kind of Shape;
Object Type Shape is for one Object Type,
	Object Type has Object Type Shape;
Object Type Shape is expanded;

Objectified Fact Type Name Shape is a kind of Shape;
Objectified Fact Type Name Shape is for one Fact Type Shape,
	Fact Type Shape has at most one Objectified Fact Type Name Shape;

Constraint Shape is a kind of Shape;
Constraint Shape is for one Constraint;

Model Note Shape is a kind of Shape;
Model Note Shape is for one Context Note;

Reading Shape is a kind of Shape;
Fact Type Shape has at most one Reading Shape,
	Reading Shape is for one Fact Type Shape;
Reading Shape is for one Reading,
	Reading has Reading Shape;

Ring Constraint Shape is a kind of Constraint Shape;
Ring Constraint Shape is attached to one Fact Type Shape;

Role Display is where
	Fact Type Shape displays Role in Ordinal position,
	Fact Type Shape displays in Ordinal position one Role;

Role Name Shape is a kind of Shape;
Role Name Shape is for one Role Display,
	Role Display has at most one Role Name Shape;

Value Constraint Shape is a kind of Constraint Shape;
Role Display has at most one Value Constraint Shape,
	Value Constraint Shape is for at most one Role Display;
Value Constraint Shape is for at most one Object Type Shape,
	Object Type Shape has Value Constraint Shape;

Component Shape is a kind of Shape;
Component Shape is for at most one Component;
parent- Component Shape contains Component Shape,
	Component Shape is contained in at most one parent- Component Shape;

either Constraint Shape is a Ring Constraint Shape or Constraint Shape is a Value Constraint Shape but not both;
for each Shape exactly one of these holds:
	Shape is an Object Type Shape,
	Shape is a Fact Type Shape,
	Shape is a Constraint Shape,
	Shape is an Objectified Fact Type Name Shape,
	Shape is a Reading Shape,
	Shape is a Role Name Shape,
	Shape is a Model Note Shape,
	Shape is a Component Shape;
either Value Constraint Shape is for Object Type Shape or Value Constraint Shape is for Role Display but not both;

/*
 * Constraints:
 */
either Component(1) belongs to Component(2) or Component(1) is a Mapping that projects some Composite but not both;
for each Component exactly one of these holds:
	Component is a Mapping,
	Component is an Indicator,
	Component is a Discriminator;
for each Concept exactly one of these holds:
	Object Type is an instance of Concept,
	Fact Type is an instance of Concept,
	Role is an instance of Concept,
	Constraint is an instance of Concept,
	Context Note is an instance of Concept,
	Unit is an instance of Concept,
	Instance is an instance of Concept,
	Fact is an instance of Concept,
	Population is an instance of Concept,
	Query is an instance of Concept;
for each Constraint exactly one of these holds:
	Constraint is a Set Constraint,
	Constraint is a Presence Constraint,
	Constraint is a Ring Constraint,
	Constraint is a Value Constraint;
either Domain Object Type is a Value Type or Domain Object Type is an Entity Type but not both;
for each Mapping exactly one of these holds:
	Mapping is an Absorption,
	Mapping is an Injection,
	Mapping is a Scoping,
	Mapping projects Composite;
for each Role Sequence exactly one of these holds:
	Role Sequence is for Reading,
	Presence Constraint covers Role Sequence,
	Subset Constraint (1) covers subset-Role Sequence,
	Subset Constraint (2) covers superset-Role Sequence,
	Role Sequence is Ordinal in Set Comparison Constraint;
either Set Comparison Constraint is a Set Exclusion Constraint or Set Comparison Constraint is a Set Equality Constraint but not both;
either Set Constraint is a Set Comparison Constraint or Set Constraint is a Subset Constraint but not both;
either Unit uses coefficient from Ephemera URL or Unit has Coefficient but not both;
either Unit is fundamental or Unit is derived from base-Unit but not both;
either Value Constraint allows Value Range or Value Constraint requires matching Regular Expression but not both;
either Value Constraint constrains Value Type or Value Constraint applies to Role but not both;
for each Mapping at most one of these holds:
	Mapping is an Absorption that flattens,
	Mapping projects Composite;
for each Instance at most one of these holds:
	Instance has Value,
	Instance objectifies Fact;
Role Value is of Instance that is of Object Type
	if and only if
	Role Value is of Role that is played by Object Type;
Role Value fulfils Fact that is of Fact Type
	if and only if
	Role Value is of Role that belongs to Fact Type;
Step specifies Fact Type that contains Role
	if and only if
	Step contains Role restricting Variable;
Variable is for Object Type that plays Role
	if and only if
	Variable is restricted by Role of Step;
/*
some Absorption traverses from some parent Role that is played by some Object Type
	only if that Absorption contains some Component that is a Mapping(2) that represents that Object Type;
some Absorption traverses to some child Role that is played by some Object Type
	only if that Absorption is a kind of Mapping that represents that Object Type;
*/
Presence Constraint is preferred identifier
	only if Presence Constraint has max Frequency;
Value Type has Scale
	only if Value Type has Length;
Variable matches nesting over Step
	only if Variable is for Object Type and Step specifies Fact Type;
either Agreement was reached by Agent or Agreement was on Date;
// either Component projects Name or Component is some Absorption that flattens;
each Concept occurs at most one time in
	Object Type is an instance of Concept;
each Concept occurs at most one time in
	Population is an instance of Concept;
each Concept occurs at most one time in
	Role is an instance of Concept;
each Discriminator occurs at least 2 times in
	Discriminator distinguishes Role using Value;
each combination Discriminator, Value occurs one time in
	Discriminator distinguishes Role using Value;
each combination Entity Type(1), Type Inheritance occurs at most one time in
	Entity Type(1) is subtype of super Entity Type(2),
	Type Inheritance provides identification;
each Presence Constraint occurs at least one time in
	Presence Constraint has min Frequency(2),
	Presence Constraint has max Frequency(1),
	Presence Constraint is mandatory;
each Role Sequence occurs at least one time in
	Role Sequence in Ordinal position includes Role;
each Set Comparison Constraint occurs at least 2 times in
	Set Comparison Constraint has in Ordinal position Role Sequence;
either Value Range has minimum Bound(2) or Value Range has maximum Bound(1);
each combination Vocabulary, Name occurs at most one time in
	Constraint belongs to Vocabulary,
	Constraint is called Name;
each combination Vocabulary, Name occurs at most one time in
	Unit is in Vocabulary,
	Unit is called Name;
