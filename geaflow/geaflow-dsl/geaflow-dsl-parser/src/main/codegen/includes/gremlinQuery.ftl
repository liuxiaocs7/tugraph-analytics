SqlCall GremlinQueryStatement():
{
    SqlCall statement = null;
}
{
    <G> statement = GremlinMatchPattern(statement)
    (
        statement = GremlinReturn(statement)
    )*
    {
        return statement;
    }
}

SqlReturnStatement GremlinReturn(SqlNode from):
{
    List<SqlNode> selectList;
    List<SqlNode> keywordList = new ArrayList<SqlNode>();
    SqlNodeList gqlReturnKeywordList;
    SqlNodeList groupBy = null;
    SqlNodeList orderBy = null;
    Span s = Span.of();
}
{
    // TODO .values  .select  ...
    <DOT>
    <VALUES>
    // properties
    <LPAREN>
    <RPAREN>
    {
        gqlReturnKeywordList = keywordList.isEmpty() ? null
        : new SqlNodeList(keywordList, s.addAll(keywordList).pos());
        // new SqlNodeList(selectList, Span.of(selectList).pos()),
        return new SqlReturnStatement(s.end(this), gqlReturnKeywordList, from,
        null, groupBy, orderBy, null, null);
    }
}

SqlMatchPattern GremlinMatchPattern(SqlNode preMatch):
{
    Span s = Span.of();
    SqlNodeList graphPattern;
    List<SqlNode> pathList = new ArrayList<SqlNode>();
    List<SqlNode> matchModeWords = new ArrayList<SqlNode>();
    SqlNode pathPattern = null;
    SqlNode condition = null;
    SqlNodeList orderBy = null;
    SqlNode count = null;
}
{
    // Only one path exists now
    pathPattern = GremlinPathPattern() { pathList.add(pathPattern); }

    // TODO WHERE condition optional

    // TODO ORDER BY optional

    // TODO LIMIT optional

    {
        graphPattern = new SqlNodeList(pathList, s.addAll(pathList).pos());
        return new SqlMatchPattern(s.end(this), preMatch, graphPattern, condition, orderBy, count);
    }
}

// need this one?
SqlPathPattern GremlinPathPatternWithAlias():
{
    SqlIdentifier pathAlias = null;
    SqlPathPattern pathPattern;
    Span s = Span.of();
}
{
    // TODO pathAlias -> .as()
    
    pathPattern = SqlPathPattern()
    {
        return new SqlPathPattern(s.end(this), pathPattern.getPathNodes(), pathAlias);
    }
}

SqlPathPattern GremlinPathPattern():
{
    Span s = Span.of();
    List<SqlNode> nodeList = new ArrayList<SqlNode>();
    SqlNodeList pathNodes;
    SqlNode nodeOrEdge = null;
}
{
    nodeOrEdge = GremlinMatchNode() { nodeList.add(nodeOrEdge); }

    // TODO add edge support g.E()

    {
        pathNodes = new SqlNodeList(nodeList, s.addAll(nodeList).pos());
        return new SqlPathPattern(s.end(this), pathNodes, null);
    }
}

SqlCall GremlinMatchNode():
{
    SqlIdentifier variable = null;
    SqlNodeList labels = null;
    SqlIdentifier label = null;
    SqlNode condition = null;
    Span s = Span.of();
}
{
    <DOT>
    <V>
    <LPAREN>
    // TODO add id
    <RPAREN>
    [
        <DOT>
        <AS>
        <LPAREN>
        variable = SimpleIdentifier()
        <RPAREN>
    ]

    [
        <DOT>
        <HASLABEL>
        <LPAREN>
        {
            List<SqlNode> labelList = new ArrayList<SqlNode>();
        }
        [
            label = SimpleIdentifier() { labelList.add(label); }
            (
                <COMMA> label = SimpleIdentifier() { labelList.add(label); }
            )*
        ]
        <RPAREN>
        {
            labels = new SqlNodeList(labelList, s.addAll(labelList).pos());
        }
    ]

    // TODO add condition statement

    {
        return new SqlMatchNode(s.end(this), variable, labels, condition);
    }
}

// get content from string node
JAVACODE String StringLiteralValue() {
    SqlNode sqlNode = StringLiteral();
    return ((NlsString) SqlLiteral.value(sqlNode)).getValue();
}


//SqlCall GremlinMatchEdge()
//{

//}
//{

//}
