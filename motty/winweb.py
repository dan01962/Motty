import mysql.connector
import csv


DB_USER = 'usr'
DATABASE = 'MOTSON'
PASSWORD = 'pswd'
HOST = 'localhost'
CNX = mysql.connector.connect(
            user=DB_USER,
            database=DATABASE,
            host=HOST,
            password=PASSWORD)



class MatchList:

    def __init__(self, season, division, max_date):

        self.division = division
        self.season = season
        self.match_index = {}
        self.home_wins = {}
        self.home_losses = {}
        self.away_wins = {}
        self.away_losses = {}
        self.wins = {}
        self.losses = {}
        self.load_matches(max_date)


    def search_for_match(self, home_team, away_team):

        if (home_team, away_team) in self.match_index:
            return self.match_index[(home_team, away_team)]
        else:
            return 1


    def get_home_wins(self):

        return self.home_wins

    def get_away_wins(self):

        return self.away_wins

    def get_home_losses(self):

        return self.home_losses

    def get_away_losses(self):

        return self.away_losses

    def get_indexed_matches(self):

        return self.match_index

    def load_matches(self, fixture_date):

        sql_str = "select *                    " + \
                  "from MOTSON.PLAYED_FIXTURES " + \
                  "where season = %s           " + \
                  "and division = %s           "
        sql_arg = (self.season, self.division)
        if fixture_date != None:
            sql_str = sql_str + "and fixture_date < %s"
            sql_arg = (self.season, self.division, fixture_date)
        cursor_matches = CNX.cursor(buffered=True, dictionary=True)
        cursor_matches.execute(sql_str, sql_arg)

        for row in cursor_matches:


            new_match = Match(row["HOME_TEAM"],
                              row["AWAY_TEAM"],
                              row["FIXTURE_DATE"],
                              row["FTR"],
                              row["FTHG"],
                              row["FTAG"])

            self.match_index[(new_match.home_team, new_match.away_team)] = new_match

            if new_match.fthg > new_match.ftag:
                self.index_home_win(new_match)
                self.index_away_loss(new_match)

                self.index_win(new_match, new_match.home_team)
                self.index_loss(new_match, new_match.away_team)

            if new_match.ftag > new_match.fthg:
                self.index_away_win(new_match)
                self.index_home_loss(new_match)

                self.index_win(new_match, new_match.away_team)
                self.index_loss(new_match, new_match.home_team)


        cursor_matches.close()


    def index_home_win(self, match):

        if match.home_team not in self.home_wins:
            self.home_wins[match.home_team] = [match]
        else:
            self.home_wins[match.home_team] = self.home_wins[match.home_team] + [match]

    def index_away_loss(self, match):

        if match.away_team not in self.away_losses:
            self.away_losses[match.away_team] = [match]
        else:
            self.away_losses[match.away_team] = self.away_losses[match.away_team] + [match]

    def index_away_win(self, match):

        if match.away_team not in self.away_wins:
            self.away_wins[match.away_team] = [match]
        else:
            self.away_wins[match.away_team] = self.away_wins[match.away_team] + [match]

    def index_home_loss(self, match):

        if match.home_team not in self.home_losses:
            self.home_losses[match.home_team] = [match]
        else:
            self.home_losses[match.home_team] = self.home_losses[match.home_team] + [match]

    def home_wins_for(self, team):

        return self.home_wins[team]

    def get_total_home_matches_for(self, team):

        total_home_matches = 0

        for match_index in self.match_index.keys():

            if match_index[0] == team:

                total_home_matches += 1

        return total_home_matches

    def get_total_away_matches_for(self, team):

        total_away_matches = 0

        for match_index in self.match_index.keys():

            if match_index[1] == team:
                total_away_matches += 1

        return total_away_matches

    def index_win(self, match, team):

        if team not in self.wins:
            self.wins[team] = [match]
        else:
            self.wins[team] = self.wins[team] + [match]

    def index_loss(self, match, team):

        if team not in self.losses:
            self.losses[team] = [match]
        else:
            self.losses[team] = self.losses[team] + [match]

    def get_wins(self):

        return self.wins

    def get_losses(self):

        return self.losses


class Match:

    def __init__(self,
                 home_team,
                 away_team,
                 fixture_date,
                 ftr,
                 fthg,
                 ftag):

        self.home_team = home_team
        self.away_team = away_team
        self.fixture_date = fixture_date
        self.ftr = ftr
        self.fthg = fthg
        self.ftag = ftag

    def __repr__(self):

        return self.home_team + ': ' + str(self.fthg) + ' ' + self.away_team + ':' + str(self .ftag)

    def other_team(self, team):

        if team == self.home_team:
            return self.away_team
        else:
            return self.home_team

    def this_teams_gd(self, team):

        if team == self.home_team:
            return self.fthg - self.ftag
        else:
            return self.ftag - self.fthg

    def get_gd(self):

        gd = self.fthg - (self.ftag  )



        if gd < 0:
            gd = gd * -1

        return gd

    def not_a_draw(self):

        if (self.fthg - self.ftag) == 0:
            return False
        else:

            return True

    def get_match_as_dictionary(self):

        match_dict = {
            'HOME_TEAM':    self.home_team,
            'AWAY_TEAM':    self.away_team,
            'FIXTURE_DATE': self.fixture_date,
            'FTR':          self.ftr,
            'FTHG':         self.fthg,
            'FTAG':         self.ftag}

        return match_dict


class AllWinWebs:

    def __init__(self, season, division, source, target, fixture_date):


        self.previous_matches = MatchList(season, division, fixture_date)
        self.home_are_home = WinWeb(source,target,self.previous_matches, 'Home')
        self.home_are_away = WinWeb(source,target,self.previous_matches, 'Away')
        self.away_are_home = WinWeb(target,source,self.previous_matches, 'Home')
        self.away_are_away = WinWeb(target,source,self.previous_matches, 'Away')

        self.home_all = WinWeb(source,target,self.previous_matches, 'All')
        self.away_all = WinWeb(target,source,self.previous_matches, 'All')


        


        print("HOME TEAM HOME++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")

        self.home_are_home.list_chains()

        print("HOME TEAM AWAY++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")

        self.home_are_away.list_chains()
        print("AWAY TEAM HOME++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")

        self.away_are_home.list_chains()

        print("AWAY TEAM AWAY++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")


        print("Home team Home:", self.home_are_home.get_gd_score())
        print("Home team Away:", self.home_are_away.get_gd_score())
        print("Away team Home:", self.away_are_home.get_gd_score())
        print("Away team Away:", self.away_are_away.get_gd_score())

        print ("Home Total=", self.home_are_away.get_gd_score() + self.away_are_home.get_gd_score())
        print ("Away Total=", self.away_are_home.get_gd_score() + self.away_are_away.get_gd_score())


        print("Tot Home-Home - no chains",self.home_are_home.total_no_chains())
        print("Tot Home-Home - avg chain length", self.home_are_home.avg_chain_length())


        print("HOME ALL......AWAY_ALL............................................")

        print("Home GD Score:" , self.home_all.get_gd_score() )
        print("Away GD Score:" , self.away_all.get_gd_score() )

        print("Home Win Score:" , self.home_all.get_match_win_score() )
        print("Away Win Score:" , self.away_all.get_match_win_score() )

    def get_stats_as_dictionary(self):


        dict_stats = {
            'HAH_GD_SCORE': self.home_are_home.get_gd_score(),
            'HAH_WIN_SCORE': self.home_are_home.get_match_win_score(),
            'HAA_GD_SCORE': self.home_are_away.get_gd_score(),
            'HAA_WIN_SCORE': self.home_are_away.get_match_win_score(),
            'HA_GD_TOT': self.home_are_home.get_gd_score() + self.home_are_away.get_gd_score(),
            'HA_WIN_TOT': self.home_are_home.get_match_win_score() + self.home_are_away.get_match_win_score(),
            'AAH_GD_SCORE': self.away_are_home.get_gd_score(),
            'AAH_WIN_SCORE': self.away_are_home.get_match_win_score(),
            'AAA_GD_SCORE': self.away_are_away.get_gd_score(),
            'AAA_WIN_SCORE': self.away_are_away.get_match_win_score(),
            'AA_GD_TOT': self.away_are_home.get_gd_score() + self.away_are_away.get_gd_score(),
            'AA_WIN_TOT': self.away_are_home.get_match_win_score() + self.away_are_away.get_match_win_score(),
            'HALL_GD_SCORE': self.home_all.get_gd_score(),
            'HALL_WIN_SCORE': self.home_all.get_match_win_score(),
            'HALL_NO_CHAINS': self.home_all.total_no_chains(),
            'AALL_GD_SCORE': self.away_all.get_gd_score(),
            'AALL_WIN_SCORE': self.away_all.get_match_win_score(),
            'AALL_NO_CHAINS': self.away_all.total_no_chains(),
            'A_GD_DIFF': (self.home_are_home.get_gd_score() + self.home_are_away.get_gd_score())- (self.away_are_home.get_gd_score() + self.away_are_away.get_gd_score()),
            'A_WIN_DIFF': (self.home_are_home.get_match_win_score() + self.home_are_away.get_match_win_score()) - (self.away_are_home.get_match_win_score() + self.away_are_away.get_match_win_score()),
            'ALL_GD_DIFF': self.home_all.get_gd_score() - self.away_all.get_gd_score(),
            'ALL_WIN_DIFF': self.home_all.get_match_win_score() - self.away_all.get_match_win_score(),
            'ALL_NO_CHAINS_DIFF': self.home_all.total_no_chains() -  self.away_all.total_no_chains()
        }

        return dict_stats





class WinWeb:


    def __init__(self, source, target, match_list, home_away_flag):

        self.chains = {}
        self.valid_web = True
        self.source = source
        self.target = target
        self.home_away_flag = home_away_flag
        self.match_list = match_list
        try:
            self.source_tree = SourceTree(source, self.match_list, home_away_flag)
            self.target_tree = TargetTree(target, self.match_list, home_away_flag)
            self.make_chains()
            print("Source Tree..........")
            print(self.source_tree)
            print("Target Tree..........")
            print(self.target_tree)

        except ValueError:
            self.valid_web = False


    def web_valid(self):

        return self.valid_web





    def make_chains(self):

        base_source_node = self.source_tree.get_base_node()

        chain = Chain()

        self.branch_chain_from_source(base_source_node, chain, self.target)


    def branch_chain_from_source(self, node, chain, target):


        print('NODE_DETAILS++++++++++++++++++', node.get_team())
        print(node.get_target_matches())

        this_source_team = node.get_team()

        if this_source_team in self.target_tree.get_non_base_nodes():

            target_node = self.target_tree.get_node_for_team(this_source_team)

            self.branch_chain_to_target(target_node, chain, target)


        if this_source_team == target:
            print("TARGET TEAM FOUND")
            chain.write_chain()
            chain_tuple = tuple(chain.match_seq)
            self.chains[chain_tuple] = chain




        elif any(node.get_target_matches()):

            duplicate_chain = True
            chain_to_branch = chain

            for team, match in node.get_target_matches().items():


                duped_chain = Chain()
                print('Match Seq',chain.get_match_seq() )
                for seq_match in chain.get_match_seq():

                    duped_chain.add_match(seq_match)

                duped_chain.add_match(match)

                new_source_node = self.source_tree.get_node_for_team(team)
                print('New Source Node:' , new_source_node)
                self.branch_chain_from_source(new_source_node, duped_chain, target)

        else:
            print("Ended Chain")





    def branch_chain_to_target(self, node, chain, target):


        print('TARGET NODE_DETAILS++++++++++++++++++', node.get_team())
        print(node.get_target_matches())


        if node.get_team() == target:
            print("TARGET TEAM FOUND IN TARGET TREE")
            chain.write_chain()
            chain_tuple = tuple(chain.match_seq)
            self.chains[chain_tuple] = chain




        elif any(node.get_target_matches()):

            for team, match in node.get_target_matches().items():


                duped_chain = Chain()
                print('Match Seq',chain.get_match_seq() )

                for seq_match in chain.get_match_seq():

                    duped_chain.add_match(seq_match)

                duped_chain.add_match(match)

                new_target_node = self.target_tree.get_node_for_team(team)
                print('New Target Node:' , new_target_node)
                self.branch_chain_to_target(new_target_node, duped_chain, target)

        else:
            print("Ended Chain")

            chain.write_chain()
            chain_tuple = tuple(chain.match_seq)

      #      self.chains[chain_tuple] = chain.match_seq

    def get_gd_score(self):

        if not self.valid_web:

            return 0

        total_score = 0
        total_matches = 0

        for chain in self.chains.values():

            total_score += chain.get_chain_gd()


        if self.home_away_flag == 'Home':

            total_source_matches = self.match_list.get_total_home_matches_for(self.source)
            total_target_matches = self.match_list.get_total_away_matches_for(self.target)
            total_matches = total_source_matches + total_target_matches

        elif self.home_away_flag == 'Away':

            total_source_matches = self.match_list.get_total_home_matches_for(self.target)
            total_target_matches = self.match_list.get_total_away_matches_for(self.source)
            total_matches = total_source_matches + total_target_matches

        else:

            total_source_matches = self.match_list.get_total_home_matches_for(self.target) \
                                 + self.match_list.get_total_away_matches_for(self.target)
            total_target_matches = self.match_list.get_total_home_matches_for(self.source) \
                                 + self.match_list.get_total_away_matches_for(self.target)

            total_matches = total_source_matches + total_target_matches



        return total_score / total_matches


    def get_match_win_score(self):

        if not self.valid_web:

            return 0

        total_matches = 0
        total_match_wins = 0

        for chain in self.chains.values():

            total_match_wins += chain.get_chain_wins()


        if self.home_away_flag == 'Home':

            #print("tot score = ", total_score)
            total_source_matches = self.match_list.get_total_home_matches_for(self.source)
            total_target_matches = self.match_list.get_total_away_matches_for(self.target)
            total_matches = total_source_matches + total_target_matches

        elif self.home_away_flag == 'Away':
            #print("tot score = ", total_score)
            total_source_matches = self.match_list.get_total_home_matches_for(self.target)
            total_target_matches = self.match_list.get_total_away_matches_for(self.source)
            total_matches = total_source_matches + total_target_matches

        else:

            total_source_matches = self.match_list.get_total_home_matches_for(self.target) \
                                   + self.match_list.get_total_away_matches_for(self.target)
            total_target_matches = self.match_list.get_total_home_matches_for(self.source) \
                                   + self.match_list.get_total_away_matches_for(self.target)

            total_matches = total_source_matches + total_target_matches

        return total_match_wins / total_matches




    def list_chains(self):

        for seq, chain in self.chains.items():

            print("New Chain-----")
            for n in seq:

               print(n, "GD= ", n.get_gd())
            print("Chain Points = %f" % chain.get_chain_gd())
            print("Edn chain")

    def total_no_chains(self):

        if not self.valid_web:

            return 0

        return len(self.chains)

    def avg_chain_length(self):

        if not self.valid_web:

            return 0

        total_length = 0
        total_chains = 0

        for chain in self.chains.values():

            total_length += chain.no_of_matches()
            total_chains += 1

        if total_chains == 0:

            return 0


        return total_length / total_chains







    def __repr__(self):

        return "Done"




class SourceTree:


    def __init__(self, base_team, match_list, home_away_flag):

        self.match_list = match_list


        self.base_team = base_team
        self.all_nodes  = {}
        self.levels = {}
        self.initialise_wins_and_losses(match_list, home_away_flag)
        self.base_level = self.create_trunk(base_team)
        self.branch_tree(self.base_level)
        self.trim_tree()

    def initialise_wins_and_losses(self, match_list, home_away_flag):

        if home_away_flag == 'Home':
            self.wins = match_list.get_home_wins()
            self.losses = match_list.get_away_losses()
        elif home_away_flag == 'Away':
            self.wins = match_list.get_away_wins()
            self.losses = match_list.get_home_losses()
        else:
            self.wins = match_list.get_wins()
            self.losses = match_list.get_losses()





    def create_trunk(self, base_team):

        # Check if this team actually has any wins, if not raise a Value Error
        if base_team not in self.wins:
            raise ValueError("The base team has no matches to branch the tree")

        # Add the base level or the trunk of the tree, add the base node to the trunk
        base_level = Level(1)
        self.base_node  = Node(base_level, base_team, self.wins, None)
        base_level.add_node(self.base_node)

        # Housekeeping all the lookups so we track which Nodes have been used and have a dict of levels in the tree
        self.all_nodes[base_team] = self.base_node
        self.levels[1] = base_level

        return base_level


    def branch_tree(self, base_level):

        this_level = base_level

        while this_level.can_be_branched_to_target() and this_level.get_level() <= 1:

            print('Processing Source LEVEL', this_level.get_level(), '+++++++++++++++++++++')

            new_level = self.branch_this_level(this_level)

            this_level = new_level

    def branch_this_level(self, last_level):

        new_level_no = last_level.get_level() + 1
        new_level = Level(new_level_no)
        self.levels[new_level_no] = new_level
        for team in last_level.get_next_level_target_teams_list():
            if team not in self.all_nodes:
                print(team)
                new_node = Node(new_level, team, self.wins, self.losses)
                self.all_nodes[team] = new_node
                new_level.add_node(new_node)
        return new_level

    def get_base_node(self):

        return self.base_node

    def get_node_for_team(self, team):

        return self.all_nodes[team]

    def __str__(self):

        for key in sorted(self.all_nodes, reverse=True):

            print('Key:', key, 'Node:', self.all_nodes[key].get_level(), self.all_nodes[key].get_target_match_teams_list())

        for key in sorted(self.levels, reverse=True):
            print('Key:', key, 'Node:', self.levels[key].get_level())

        return "Done"


    def next_level_to_source(self, level):

        this_level_no = level.get_level()
        next_level_no = this_level_no - 1
        if next_level_no in self.levels:
            return self.levels[next_level_no]
        else:
            return 0

    def next_level_to_target(self, level):

        this_level_no = level.get_level()
        next_level_no = this_level_no + 1

        if next_level_no in self.levels:
            return self.levels[next_level_no]
        else:
            return 0


    def trim_tree(self):

        print("TRIM TREE ROUTINE+++++++++++++++++++++++++++")

        for team, node in self.all_nodes.items():

            valid_target_nodes = []
            valid_source_nodes = []
            node_level = node.get_level()

            print("trimming team: ", team, 'on level:', node_level)
            print('---------------------')

            print(self.next_level_to_source(node_level))
            print(self.next_level_to_target(node_level))


            if self.next_level_to_source(node_level):
                valid_source_nodes = self.next_level_to_source(node_level).get_nodes().keys()
                print('valid source nodes:', valid_source_nodes)


            if self.next_level_to_target(node_level):
                valid_target_nodes = self.next_level_to_target(node_level).get_nodes().keys()

                print('valid target nodes:', valid_target_nodes)

            node.trim_node(valid_source_nodes, valid_target_nodes)





            print('---------------------')

        print("END - TRIM TREE ROUTINE+++++++++++++++++++++++++++")

    def get_non_base_nodes(self):

        non_base_nodes = {}
        for team, node in self.all_nodes.items():

            if team != self.base_team:
                non_base_nodes[team] = node

        return non_base_nodes


class TargetTree(SourceTree):

    def initialise_wins_and_losses(self, match_list, home_away_flag):

        if home_away_flag == 'Home':
            self.wins = match_list.get_home_wins()
            self.losses = match_list.get_away_losses()
        elif home_away_flag == 'Away':
            self.wins = match_list.get_away_wins()
            self.losses = match_list.get_home_losses()
        else:

            self.wins = match_list.get_wins()
            self.losses = match_list.get_losses()

    def create_trunk(self, base_team):

        # Check if this team actually has any losses, if not raise a Value Error
        if base_team not in self.losses:
            print("No losses for:" , base_team)
            raise ValueError("The base team has no lost matches with which to branch the target tree")

        # Add the base level or the trunk of the tree, add the base node to the trunk
        base_level = Level(1)
        base_node  = Node(base_level, base_team, None, self.losses)
        base_level.add_node(base_node)

        # Housekeeping all the lookups so we track which Nodes have been used and have a dict of levels in the tree
        self.all_nodes[base_team] = base_node
        self.levels[1] = base_level

        return base_level


    def branch_tree(self, base_level):

        this_level = base_level

        while this_level.can_be_branched_to_source() and this_level.get_level() <= 1:

            print('Processing Target LEVEL', this_level.get_level(), '+++++++++++++++++++++')

            new_level = self.branch_this_level(this_level)

            this_level = new_level

    def branch_this_level(self, last_level):

        new_level_no = last_level.get_level() + 1
        new_level = Level(new_level_no)
        self.levels[new_level_no] = new_level
        for team in last_level.get_next_level_source_teams_list():
            if team not in self.all_nodes:
                print(team)
                new_node = Node(new_level, team, self.wins, self.losses)
                self.all_nodes[team] = new_node
                new_level.add_node(new_node)
        return new_level

    def next_level_to_source(self, level):

        this_level_no = level.get_level()
        next_level_no = this_level_no + 1
        if next_level_no in self.levels.keys():
            return self.levels[next_level_no]
        else:
            return 0

    def next_level_to_target(self, level):

        this_level_no = level.get_level()
        next_level_no = this_level_no - 1

        if next_level_no in self.levels.keys():
            return self.levels[next_level_no]
        else:
            return 0



class Level:


    def __init__(self, level):
        self.level = level
        self.nodes = {}


    def add_node(self, node):

        team = node.team
        self.nodes[team] = node

    def can_be_branched_to_source(self):

        for key, node in self.nodes.items():

            if node.source_matches:
                return True

        return False

    def can_be_branched_to_target(self):

        for key, node in self.nodes.items():


            if node.target_matches:
                return True

        print('LEVEVL CANT BE BRANCHED')

        return False

    def get_level(self):

        return self.level

    def get_next_level_target_teams_list(self):

        target_teams = []

        for key, node in self.nodes.items():

            for team in node.get_target_match_teams_list():

                target_teams.append(team)


        return target_teams


    def get_next_level_source_teams_list(self):

        source_teams = []

        for key, node in self.nodes.items():

            for team in node.get_source_match_teams_list():

                source_teams.append(team)


        return source_teams

    def get_nodes(self):

        return self.nodes

    def trim_level(self, calling_tree):
        pass




    def __repr__(self):

        return "Level: " + str(self.level)



class Node:

    def __init__(self, level, team, wins, losses):


        self.level = level
        self.team = team
        self.score = 0
        self.source_matches = {}
        self.target_matches = {}
        if wins:
            self.add_target_matches(wins)
        if losses:
            self.add_source_matches(losses)

    def add_target_matches(self, wins):

        if self.team in wins:
            for match in wins[self.team]:
                self.add_target_match(match)

    def add_source_matches(self, losses):

        if self.team in losses:
            for match in losses[self.team]:
                self.add_source_match(match)

    def add_target_match(self, match):

        target_team = match.other_team(self.team)
        self.target_matches[target_team] = match

    def add_source_match(self, match):

        target_team = match.other_team(self.team)
        self.source_matches[target_team] = match

    def get_target_match_teams_list(self):

        return self.target_matches.keys()

    def get_source_match_teams_list(self):

        return self.source_matches.keys()

    def get_target_matches(self):

        return self.target_matches

    def get_level(self):

        return self.level

    def get_team(self):

        return self.team

    def trim_node(self, valid_source_nodes, valid_target_nodes):

        source_del_list = []
        target_del_list = []

        for team in self.source_matches.keys():
            if team not in valid_source_nodes:
                source_del_list = source_del_list + [team]


        for team in source_del_list:
            del self.source_matches[team]
        print('source del list', source_del_list)


        for team in self.target_matches.keys():
            if team not in valid_target_nodes:
                target_del_list = target_del_list + [team]

        for team in target_del_list:
            del self.target_matches[team]

        print('target del list', target_del_list)

        print('FINAL TARGET NODES:', self.target_matches.keys())












    def __str__(self):

        print('_______________ START NODE:', self.team)

        print('-------------------- Target Matches:')
        for key, match in self.target_matches.items():
            print('-------------------------', match.other_team(self.team), 'GD=', match.this_teams_gd(self.team))
        return '_______________ END NODE: ' + self.team



class Chain:

    def __init__(self):

        self.match_seq = []

    def add_match(self, match):

        self.match_seq.append(match)

    def get_match_seq(self):

        return self.match_seq



    def clone_match_seq(self, match_seq):

        self.match_seq = match_seq

    def get_chain_gd(self):

        total_gd = 0
        matches = 0

        for match in self.match_seq:

            total_gd += match.get_gd()
            matches += 1


        return float(total_gd / matches)

    def get_chain_wins(self):

        total_wins = 0
        matches = 0

        for match in self.match_seq:

            if match.not_a_draw():
                total_wins += 1
            matches += 1


        return float(total_wins / matches)



    def write_chain(self):

        print("WRITE_CHAIN")
        print("------------------------------------------------------------")
        for match in self.match_seq:
            print(match)
        print("------------------------------------------------------------")

    def duplicate_chain(self):

        new_chain = Chain()
        new_chain.clone_match_seq(self.match_seq)

        return new_chain

    def no_of_matches(self):

        return len(self.match_seq)








class WinWebViewer:

    def __init__(self):

        pass






def test_season():
    sql_str = "select distinct season as `SEASON`, division as `DIVISION` from played_fixtures where division = 'E0' and season > 10 order by 1,2"
    cursor_matches = CNX.cursor(buffered=True, dictionary=True)
    cursor_matches.execute(sql_str)

    win_web_results = []

    for row in cursor_matches:


        process_season(row['SEASON'], row['DIVISION'], win_web_results)



    with open('winebtesting.csv', 'w') as csvfile:
        fieldnames = [
            'HOME_TEAM',
            'AWAY_TEAM',
            'FIXTURE_DATE',
            'FTR',
            'FTHG',
            'FTAG',
            'HAH_GD_SCORE',
            'HAH_WIN_SCORE',
            'HAA_GD_SCORE',
            'HAA_WIN_SCORE',
            'HA_GD_TOT' ,
            'HA_WIN_TOT' ,
            'AAH_GD_SCORE',
            'AAH_WIN_SCORE',
            'AAA_GD_SCORE',
            'AAA_WIN_SCORE',
            'AA_GD_TOT',
            'AA_WIN_TOT',
            'HALL_GD_SCORE',
            'HALL_WIN_SCORE',
            'HALL_NO_CHAINS',
            'AALL_GD_SCORE',
            'AALL_WIN_SCORE',
            'AALL_NO_CHAINS',
            'A_GD_DIFF',
            'A_WIN_DIFF',
            'ALL_GD_DIFF',
            'ALL_WIN_DIFF',
            'ALL_NO_CHAINS_DIFF']


        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for row in win_web_results:
            writer.writerow(row)



def process_season(season, division, win_web_results):

    seasons_matches = MatchList(season, division, None)

    for key, match in seasons_matches.get_indexed_matches().items():

        all_stats = AllWinWebs(season, 'E0', match.home_team, match.away_team, match.fixture_date)

        dict_to_write =  match.get_match_as_dictionary()
        dict_to_write.update(all_stats.get_stats_as_dictionary())

        win_web_results.append(dict_to_write)






ww = AllWinWebs(15,'E0','Southampton','Aston Villa', '2015-12-05')

print(ww)

test_season()




















