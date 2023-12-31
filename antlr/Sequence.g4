grammar Sequence;

fragment HEXA: [1-9a-fA-F][0-9a-fA-F]* | '0';

WHITESPACE: [ \t\r\n]+ -> skip;
ZERO: '0';
NUM: [1-9][0-9]*;
WILDCARDAS: '-' '0';
LEGACYAS: '-' NUM;
AS: '-' HEXA ':' HEXA ':' HEXA;
HASH: '#';
COMMA: ',';
QUESTIONMARK: '?';
PLUS: '+';
ASTERISK: '*';
OR: '|';
LPAR: '(';
RPAR: ')';

MONKEYTAIL: '@';
GLOBALPOLICY: 'G';
LOCALPOLICY: 'L';
WILDCARDPOLICY: 'A';

start: sequence EOF;

sequence
    : sequence QUESTIONMARK # QuestionMark
    | sequence PLUS         # Plus
    | sequence ASTERISK     # Asterisk
    | sequence OR sequence  # Or
    | sequence sequence     # Concatenation
    | LPAR sequence RPAR    # Parentheses
    | onehop MONKEYTAIL onepolicy # OnePolicyHop
    | onehop MONKEYTAIL LPAR policies RPAR # PoliciesHop
    | onehop                # Hop
    ;

onehop
    : isd                            # ISDHop
    | isd as                         # ISDASHop
    | isd as HASH iface              # ISDASIFHop
    | isd as HASH iface COMMA iface  # ISDASIFIFHop
    ;

isd
    : ZERO # WildcardISD
    | NUM  # ISD
    ;

as
    : WILDCARDAS # WildcardAS
    | LEGACYAS   # LegacyAS
    | AS         # AS
    ;

iface
    : ZERO # WildcardIFace
    | NUM  # IFace
    ;

policies
    : policies OR policies # PoliciesOr
    | policies COMMA policies # PoliciesConcatenation
    | LPAR policies RPAR # PoliciesParentheses
    | onepolicy # PoliciesPolicy
    ;

onepolicy
    : GLOBALPOLICY policyindex # GlobalPolicy
    | LOCALPOLICY policyindex # LocalPolicy
    | WILDCARDPOLICY # WildcardPolicy
    ;

policyindex
    : ZERO # PolicyIndexWildcard
    | NUM # PolicyIndex
    ;
