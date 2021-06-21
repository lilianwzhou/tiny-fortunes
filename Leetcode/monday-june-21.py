#  WE WILL MAKE A FILE PER DAY
#  Monday, June 21:

# https://leetcode.com/problems/middle-of-the-linked-list/

# So you click the leetcode link for whatever day we r on, you copy their boilerplate as I do below

# NOTICE I UNCOMMENT THE CLASS DEFINITION ListNode below bc we are going to need it, leetcode normally 
# keeps it commented bc they have it internally when you click run but for us we need this declaration in 
# code

# Definition for singly-linked list.
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next
class Solution:
    def middleNode(self, head: ListNode) -> ListNode:

        # TODO: just like always u fill in the function

        # Delete this line first, just here to silence syntax errors since the function
        # requires a listnode out
        return ListNode(0)


# Then to test u would like make cases down here/run through your head and once you are sure
# enough about ur solution then you would copy paste 16 -> 23 and dump into leetcode and run it against their tests
# It should b RARE that you fail Leetcode submit button bc i want u to think through ur solutions before
# you run their test suite and not just b guessin

# Example test case for this question -> you would make a couple of these just to see if ur solution works like you thought

# create a linked list 1->2->3
nodeOne = ListNode(1)
nodeTwo = ListNode(2)
nodeThree = ListNode(3)
nodeOne.next = nodeTwo
nodeTwo.next = nodeThree

# instance of the class that calls middleNode() with head being nodeOne
test = Solution().middleNode(nodeOne)

# what you expect out you wanna verify and else you print what you actually got and the result for debugging
# you can add prints within your code and see where you are going wrong too
if test.val == 2:
    print("Success for list 1->2->3")
else:
    print(f"We fucked up and got {test.val}")
    print(test)

# Then you would run this by the run button in the top right in VSCODE or you would open terminal to this leetcode folder
# and do python3 monday-june-21.py, whichever is easier/works
        