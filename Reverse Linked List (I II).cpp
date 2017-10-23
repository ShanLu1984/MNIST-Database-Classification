/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */

// Reverse Linked List I: iteratively

class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        if (!head || !head->next) return head;
        ListNode* pre = nullptr;
        ListNode* c = head;
        while (c) {
            ListNode* temp = c->next;
            c->next = pre;
            pre = c;
            c = temp;
        }
        return pre;
    }
};


// Reverse Linked List I: recursively

class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        if (!head || !head->next) return head;
        ListNode* newhead = reverseList(head->next);
        head->next->next = head;
        head->next = nullptr;
        return newhead;
    }
};

// Reverse Linked List II: iteratively

class Solution {
public:
    ListNode* reverseBetween(ListNode* head, int m, int n) {
        ListNode* d = new ListNode(0);
        d->next = head;
        ListNode* pre = d;
        ListNode* c = head;
        int i = 1;
        while (i < m) {
            pre = pre->next;
            c = c->next;
            i++;
        }
        // pre is the first nodes before the reversed part; c is the first node of the reversed part; 
        // i == m
        // do the reverse process
        ListNode* c_pre = nullptr;
        while (i <= n) {
            ListNode* pos = c->next;
            c->next = c_pre;
            c_pre = c;
            c = pos;
            i++;
        }
        // after the reverse, c_pre is the first one in the reversed part, c is the first node after the reversed part;
        // pre->next point to the last one of the reversed part.
        pre->next->next = c;
        pre->next = c_pre;
        return d->next;
    }
};