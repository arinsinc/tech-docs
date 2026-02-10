# Distributed Systems

## Table of Contents
1. [Introduction](#introduction)
2. [Core Concepts](#core-concepts)
3. [CAP Theorem](#cap-theorem)
4. [Consistency Models](#consistency-models)
5. [Distributed System Patterns](#distributed-system-patterns)
6. [Consensus Algorithms](#consensus-algorithms)
7. [Data Partitioning](#data-partitioning)
8. [Replication Strategies](#replication-strategies)
9. [Fault Tolerance](#fault-tolerance)
10. [Distributed Transactions](#distributed-transactions)
11. [Message Queues and Event Streaming](#message-queues-and-event-streaming)
12. [Service Discovery](#service-discovery)
13. [Load Balancing](#load-balancing)
14. [Distributed Caching](#distributed-caching)
15. [Observability](#observability)
16. [Common Challenges](#common-challenges)
17. [Real-World Systems](#real-world-systems)

---

## Introduction

### What is a Distributed System?

A **distributed system** is a collection of independent computers that appear to users as a single coherent system. Components communicate and coordinate through message passing over a network.

### Why Distributed Systems?

1. **Scalability**: Handle increasing load by adding machines
2. **Availability**: System remains operational despite failures
3. **Performance**: Distribute workload, reduce latency
4. **Geographic Distribution**: Serve users globally
5. **Fault Tolerance**: No single point of failure

### Challenges

1. **Network Unreliability**: Messages can be lost, delayed, duplicated
2. **Partial Failures**: Some components fail while others work
3. **Concurrency**: Multiple operations happening simultaneously
4. **Clock Synchronization**: No global clock
5. **Consistency**: Keeping data consistent across nodes

### Key Characteristics

- **No shared memory**: Components communicate via messages
- **Concurrent execution**: Multiple processes run simultaneously
- **Independent failures**: Components fail independently
- **Asynchronous communication**: No guaranteed timing

---

## Core Concepts

### 1. **Nodes**
Individual computers/servers in the system

### 2. **Network**
Communication medium connecting nodes

### 3. **State**
Data stored across distributed nodes

### 4. **Messages**
Data exchanged between nodes

### 5. **Protocols**
Rules for communication and coordination

### 6. **Partitioning (Sharding)**
Splitting data across multiple nodes

### 7. **Replication**
Copying data across multiple nodes

### 8. **Consensus**
Agreement among nodes on system state

---

## CAP Theorem

### The Theorem

**You can only guarantee 2 out of 3:**

1. **Consistency (C)**: All nodes see the same data at the same time
2. **Availability (A)**: Every request receives a response (success/failure)
3. **Partition Tolerance (P)**: System continues despite network partitions

```
      Consistency
         /\
        /  \
       /    \
      /  CA  \
     /        \
    /__________ \
   /\          /\
  /  \   CP   /  \
 /    \      /    \
/  AP  \    /  PA  \
/_______\  /________\
Availability      Partition
                  Tolerance
```

### Trade-offs

#### CA Systems (Consistency + Availability)
- Single-node databases (PostgreSQL, MySQL in single instance)
- **Trade-off**: Cannot handle network partitions
- **Rare in practice**: Networks always partition

#### CP Systems (Consistency + Partition Tolerance)
- MongoDB, HBase, Redis (with certain configs)
- **Trade-off**: May become unavailable during partitions
- **Use case**: Banking, financial systems

#### AP Systems (Availability + Partition Tolerance)
- Cassandra, DynamoDB, Cosmos DB
- **Trade-off**: May serve stale data
- **Use case**: Social media, real-time analytics

### Example Scenario

```
Network Partition Occurs:
DC1: [Node A, Node B]  ||||  DC2: [Node C, Node D]

CP Choice: Reject writes until partition heals (maintain consistency)
AP Choice: Accept writes on both sides (risk inconsistency)
```

### PACELC Extension

**PACELC**: If Partition (P), choose Availability (A) or Consistency (C), Else (E) choose Latency (L) or Consistency (C)

- **PA/EL**: DynamoDB, Cassandra (availability + low latency)
- **PC/EC**: HBase, MongoDB (consistency over performance)
- **PA/EC**: Cosmos DB with eventual consistency (configurable)

---

## Consistency Models

### 1. **Strong Consistency**

After a write, all subsequent reads return the new value.

```
Client A: Write(x=5)  ✓
          |
          v
All Nodes: x=5
          |
Client B: Read(x) → 5  ✓
```

**Examples**: Single-node databases, ZooKeeper, etcd

### 2. **Eventual Consistency**

After a write, reads eventually return the new value (given no new updates).

```
Client A: Write(x=5)  ✓
          |
Node 1:   x=5 (immediate)
Node 2:   x=3 (stale)
          |
Time passes...
          |
Node 2:   x=5 (eventual)
```

**Examples**: DNS, Cassandra, DynamoDB

### 3. **Causal Consistency**

Operations that are causally related are seen in the same order by all nodes.

```
Client A: Write(x=5)  →  Client B: Read(x) → 5
                         Client B: Write(y=x+1) → y=6

All nodes see: x=5 happened before y=6
```

**Examples**: COPS, Eiger

### 4. **Sequential Consistency**

All nodes see operations in the same order, but not necessarily real-time order.

```
Client A: Write(x=1)    Client B: Write(y=2)

Valid orders:
- x=1 then y=2 (all nodes see this)
- y=2 then x=1 (all nodes see this)

Invalid:
- Node 1 sees x=1 then y=2
- Node 2 sees y=2 then x=1 (different order)
```

### 5. **Linearizability**

Strongest consistency: Operations appear instantaneous and in real-time order.

```
Timeline: ----[Write x=5]----[Read x]----
               |              |
               v              v
Result:        ✓              5 (must see latest)
```

**Examples**: Spanner, CockroachDB

### Consistency Hierarchy

```
Linearizable (Strongest)
    ↓
Sequential
    ↓
Causal
    ↓
Eventual (Weakest)
```

---

## Distributed System Patterns

### 1. **Leader-Follower (Master-Slave)**

```
     Leader
    /  |  \
   /   |   \
  F1   F2   F3
(Followers)
```

- **Writes**: Go to leader, replicated to followers
- **Reads**: Can read from followers (may be stale)
- **Use case**: MySQL replication, Kafka

### 2. **Peer-to-Peer (P2P)**

```
  N1 ← → N2
  ↕       ↕
  N3 ← → N4
```

- All nodes are equal
- No single point of failure
- **Use case**: BitTorrent, Cassandra

### 3. **Client-Server**

```
  C1    C2    C3
   \    |    /
    \   |   /
      Server
```

- Centralized server handles requests
- **Use case**: HTTP, traditional web apps

### 4. **Publish-Subscribe**

```
Publishers → Topic → Subscribers
  P1           T1        S1
  P2     →     T2   →    S2
  P3           T3        S3
```

- Decoupled communication
- **Use case**: Kafka, RabbitMQ, Redis Pub/Sub

### 5. **CQRS (Command Query Responsibility Segregation)**

```
Commands → Write Model → Event Store
                         ↓
            Read Model ← Projections
                         ↑
Queries ← ← ← ← ← ← ← ← ←
```

- Separate read and write paths
- **Use case**: Event-sourced systems

### 6. **Saga Pattern**

```
Service A  →  Service B  →  Service C
   ✓              ✗              -
   |              |
Compensate ← ← ← ←
```

- Distributed transactions via compensating actions
- **Use case**: Microservices transactions

### 7. **Circuit Breaker**

```
     Closed (Normal)
          ↓ (failures exceed threshold)
     Open (Fail fast)
          ↓ (timeout)
     Half-Open (Test)
          ↓ (success)
     Closed
```

- Prevent cascading failures
- **Use case**: Resilience4j, Hystrix

### 8. **Bulkhead**

```
Thread Pool A  Thread Pool B
  [||||||]      [||||||]
    ↓               ↓
  Service 1     Service 2
```

- Isolate resources
- **Use case**: Preventing resource exhaustion

---

## Consensus Algorithms

### Why Consensus?

Nodes must agree on:
- Leader election
- State machine replication
- Atomic commit
- Configuration changes

### 1. **Paxos**

#### Phases

**Phase 1: Prepare**
```
Proposer → Acceptors: Prepare(n)
Acceptors → Proposer: Promise(n, value_accepted)
```

**Phase 2: Accept**
```
Proposer → Acceptors: Accept(n, value)
Acceptors → Proposer: Accepted(n, value)
Acceptors → Learners: Learn(value)
```

#### Characteristics
- Strong consistency
- Complex to implement
- Used in Google Chubby

### 2. **Raft**

#### Simpler than Paxos

**Components:**
- Leader election
- Log replication
- Safety

**States:**
```
Follower → Candidate → Leader
   ↑                      |
   └──────────────────────┘
```

**Leader Election:**
```
1. Follower timeout → becomes Candidate
2. Candidate requests votes
3. Majority votes → becomes Leader
4. Leader sends heartbeats
```

**Log Replication:**
```
Client → Leader: Command
Leader → Followers: AppendEntries(command)
Followers → Leader: ACK
Leader: Commit + Apply to state machine
Leader → Followers: Commit index update
```

#### Example Implementation (Simplified)

```java
class RaftNode {
    enum State { FOLLOWER, CANDIDATE, LEADER }
    
    State state = FOLLOWER;
    int currentTerm = 0;
    String votedFor = null;
    List<LogEntry> log = new ArrayList<>();
    int commitIndex = 0;
    
    // Election timeout triggers
    void onElectionTimeout() {
        state = CANDIDATE;
        currentTerm++;
        votedFor = this.id;
        int votesReceived = 1;
        
        for (RaftNode peer : peers) {
            RequestVoteResponse response = 
                peer.requestVote(currentTerm, this.id, log.size(), currentTerm);
            
            if (response.voteGranted) {
                votesReceived++;
            }
        }
        
        if (votesReceived > peers.size() / 2) {
            state = LEADER;
            sendHeartbeats();
        }
    }
    
    // Leader sends heartbeats
    void sendHeartbeats() {
        while (state == LEADER) {
            for (RaftNode peer : peers) {
                peer.appendEntries(currentTerm, this.id, log, commitIndex);
            }
            Thread.sleep(HEARTBEAT_INTERVAL);
        }
    }
}
```

### 3. **Byzantine Fault Tolerance (BFT)**

Handles malicious/faulty nodes.

**PBFT (Practical Byzantine Fault Tolerance):**

```
Client → Primary: Request
Primary → Replicas: Pre-Prepare
Replicas ↔ Replicas: Prepare (broadcast)
Replicas ↔ Replicas: Commit (broadcast)
Replicas → Client: Reply

Client waits for f+1 matching replies (where f = max faulty nodes)
```

**Requirements**: Needs 3f+1 replicas to tolerate f faults

**Use case**: Blockchain (Bitcoin, Ethereum)

---

## Data Partitioning

### Why Partition?

- Distribute load across nodes
- Scale beyond single machine capacity
- Improve query performance

### 1. **Horizontal Partitioning (Sharding)**

Split rows across nodes.

```
Users Table:
Shard 1: Users 1-1000
Shard 2: Users 1001-2000
Shard 3: Users 2001-3000
```

### 2. **Vertical Partitioning**

Split columns across nodes.

```
Users Table:
Node 1: id, name, email
Node 2: id, address, phone
Node 3: id, preferences, settings
```

### Partitioning Strategies

#### A. **Range-Based Partitioning**

```
Partition 1: A-G
Partition 2: H-N
Partition 3: O-Z
```

**Pros**: Simple, range queries efficient  
**Cons**: Uneven distribution, hotspots

#### B. **Hash-Based Partitioning**

```java
int partition = hash(key) % numPartitions;
```

**Pros**: Even distribution  
**Cons**: Range queries difficult, rebalancing expensive

#### C. **Consistent Hashing**

```
        Node A (hash=100)
           /    \
          /      \
    Keys 51-100  Keys 0-50
         |          |
    Node C        Node B
   (hash=50)    (hash=200)
```

**Hash Ring:**
- Nodes and keys mapped to ring
- Key goes to next node clockwise
- Adding/removing node affects only neighbors

**Implementation:**

```java
class ConsistentHash<T> {
    private TreeMap<Integer, T> ring = new TreeMap<>();
    private int virtualNodes = 150;
    
    public void addNode(T node) {
        for (int i = 0; i < virtualNodes; i++) {
            int hash = hash(node.toString() + i);
            ring.put(hash, node);
        }
    }
    
    public T getNode(String key) {
        int hash = hash(key);
        Map.Entry<Integer, T> entry = ring.ceilingEntry(hash);
        return entry != null ? entry.getValue() : ring.firstEntry().getValue();
    }
    
    private int hash(String key) {
        return Hashing.murmur3_32().hashString(key, UTF_8).asInt();
    }
}
```

**Pros**: Minimal rebalancing, even distribution  
**Cons**: More complex

#### D. **Directory-Based Partitioning**

```
Lookup Table:
Key → Partition
A-D → P1
E-H → P2
I-L → P3
```

**Pros**: Flexible, can rebalance  
**Cons**: Lookup overhead, single point of failure

### Rebalancing

**Strategies:**
1. **Fixed partitions**: Pre-create many partitions, move whole partitions
2. **Dynamic partitioning**: Split/merge based on size
3. **Proportional partitions**: Fixed partitions per node

---

## Replication Strategies

### Why Replicate?

- **High availability**: Survive node failures
- **Read scalability**: Distribute read load
- **Latency**: Place data closer to users
- **Fault tolerance**: Multiple copies

### 1. **Single-Leader Replication**

```
    Leader (Writes)
    /    |    \
   /     |     \
  F1     F2     F3
(Read)  (Read) (Read)
```

**Process:**
1. Client writes to leader
2. Leader replicates to followers
3. Followers acknowledge
4. Leader confirms to client

**Replication Types:**

**Synchronous:**
```
Client → Leader → Follower 1 (wait) ✓
                  Follower 2 (wait) ✓
         Leader → Client: ACK
```
- **Pros**: Strong consistency
- **Cons**: Slower, single slow follower blocks all writes

**Asynchronous:**
```
Client → Leader → Client: ACK (immediate)
         Leader → Followers (background)
```
- **Pros**: Fast writes
- **Cons**: Potential data loss if leader fails

**Semi-synchronous:**
```
Wait for 1 follower, others async
```

### 2. **Multi-Leader Replication**

```
Leader 1 (DC1) ←→ Leader 2 (DC2) ←→ Leader 3 (DC3)
   |                 |                  |
Followers         Followers          Followers
```

**Use cases:**
- Multi-datacenter
- Offline clients
- Collaborative editing

**Conflict Resolution:**

**Last Write Wins (LWW):**
```
User A: Write x=1 at t=100
User B: Write x=2 at t=101
Result: x=2 (timestamp wins)
```

**Version Vectors:**
```
User A: {A:1, B:0} → x=1
User B: {A:0, B:1} → x=2
Conflict detected, resolve manually
```

**Operational Transformation:**
```
User A: Insert "X" at position 5
User B: Insert "Y" at position 3
Transform operations to maintain intent
```

### 3. **Leaderless Replication**

```
  Client
  / | | \
 /  | |  \
N1 N2 N3 N4
```

**Quorum:**
- n = total replicas
- w = write confirmations required
- r = read confirmations required

**Quorum condition**: w + r > n

**Examples:**
- n=3, w=2, r=2 (common)
- n=5, w=3, r=3

**Write Process:**
```java
public boolean write(String key, String value) {
    int successCount = 0;
    List<Node> nodes = getNodesForKey(key);
    
    for (Node node : nodes) {
        if (node.write(key, value, timestamp())) {
            successCount++;
        }
    }
    
    return successCount >= WRITE_QUORUM;
}
```

**Read Repair:**
```
Read from multiple nodes:
N1: x=5 (v2)
N2: x=3 (v1)  ← stale
N3: x=5 (v2)

Return x=5, update N2 in background
```

**Anti-Entropy:**
Background process compares replicas and syncs differences.

---

## Fault Tolerance

### Types of Failures

1. **Fail-Stop**: Node crashes, stops responding
2. **Network Partition**: Nodes can't communicate
3. **Byzantine**: Nodes behave maliciously
4. **Performance**: Slow nodes (stragglers)

### Techniques

#### 1. **Redundancy**

```
Primary ← Client → Backup
  |                  |
[Data]            [Data]
```

#### 2. **Checkpointing**

```
State @ t0 → Checkpoint
State @ t1 → Checkpoint
Crash @ t2
Recovery: Restore from t1 checkpoint
```

#### 3. **Heartbeats & Timeouts**

```java
class FailureDetector {
    private Map<String, Long> lastHeartbeat = new ConcurrentHashMap<>();
    private static final long TIMEOUT_MS = 5000;
    
    public void receiveHeartbeat(String nodeId) {
        lastHeartbeat.put(nodeId, System.currentTimeMillis());
    }
    
    public boolean isNodeAlive(String nodeId) {
        Long last = lastHeartbeat.get(nodeId);
        return last != null && 
               System.currentTimeMillis() - last < TIMEOUT_MS;
    }
    
    public List<String> getDeadNodes() {
        return lastHeartbeat.entrySet().stream()
            .filter(e -> !isNodeAlive(e.getKey()))
            .map(Map.Entry::getKey)
            .collect(Collectors.toList());
    }
}
```

#### 4. **Retries with Backoff**

```java
public Response callServiceWithRetry() {
    int attempts = 0;
    int maxAttempts = 5;
    int backoffMs = 100;
    
    while (attempts < maxAttempts) {
        try {
            return service.call();
        } catch (TransientException e) {
            attempts++;
            if (attempts >= maxAttempts) {
                throw new MaxRetriesExceededException();
            }
            Thread.sleep(backoffMs * (1 << attempts)); // Exponential backoff
        }
    }
}
```

#### 5. **Circuit Breaker**

```java
class CircuitBreaker {
    enum State { CLOSED, OPEN, HALF_OPEN }
    
    private State state = State.CLOSED;
    private int failureCount = 0;
    private int threshold = 5;
    private long openStateStart;
    private long timeout = 60000; // 60 seconds
    
    public Response call(Supplier<Response> supplier) {
        if (state == State.OPEN) {
            if (System.currentTimeMillis() - openStateStart > timeout) {
                state = State.HALF_OPEN;
            } else {
                throw new CircuitBreakerOpenException();
            }
        }
        
        try {
            Response response = supplier.get();
            onSuccess();
            return response;
        } catch (Exception e) {
            onFailure();
            throw e;
        }
    }
    
    private void onSuccess() {
        failureCount = 0;
        state = State.CLOSED;
    }
    
    private void onFailure() {
        failureCount++;
        if (failureCount >= threshold) {
            state = State.OPEN;
            openStateStart = System.currentTimeMillis();
        }
    }
}
```

---

## Distributed Transactions

### ACID in Distributed Systems

- **Atomicity**: All or nothing across nodes
- **Consistency**: Maintain invariants
- **Isolation**: Concurrent transactions don't interfere
- **Durability**: Committed data persists

### 1. **Two-Phase Commit (2PC)**

```
Coordinator
    |
    |--- Prepare Phase --->
    |                      \
Participant A        Participant B
    |                      |
    |<---- Vote Yes -------|
    |<---- Vote Yes -------|
    |
    |--- Commit Phase ---->
    |                      \
    |                    Commit
    |<---- ACK ------------|
```

**Algorithm:**

**Phase 1: Prepare**
```
Coordinator → All participants: PREPARE
Participants: Acquire locks, write to temp log
Participants → Coordinator: YES or NO
```

**Phase 2: Commit/Abort**
```
If all YES:
    Coordinator → All: COMMIT
    Participants: Make changes permanent
Else:
    Coordinator → All: ABORT
    Participants: Rollback
```

**Problems:**
- Blocking: If coordinator crashes, participants wait
- Not partition-tolerant

### 2. **Three-Phase Commit (3PC)**

Adds pre-commit phase to reduce blocking.

```
1. Prepare Phase
2. Pre-Commit Phase (can timeout)
3. Commit Phase
```

### 3. **Saga Pattern**

Long-running transactions via compensating actions.

```
Order Service: Create Order ✓
    → Payment Service: Charge Card ✓
        → Inventory Service: Reserve Items ✗
            ← Payment Service: Refund Card (compensate)
                ← Order Service: Cancel Order (compensate)
```

**Implementation:**

```java
public class OrderSaga {
    
    public void executeOrderSaga(Order order) {
        try {
            // Step 1
            orderService.createOrder(order);
            
            // Step 2
            Payment payment = paymentService.chargeCard(order);
            
            // Step 3
            inventoryService.reserveItems(order);
            
            // Success
            orderService.confirmOrder(order);
            
        } catch (Exception e) {
            // Compensate in reverse order
            compensate(order);
        }
    }
    
    private void compensate(Order order) {
        try {
            inventoryService.releaseReservation(order);
        } catch (Exception e) { /* log */ }
        
        try {
            paymentService.refundCard(order);
        } catch (Exception e) { /* log */ }
        
        try {
            orderService.cancelOrder(order);
        } catch (Exception e) { /* log */ }
    }
}
```

**Saga Coordination:**

**Choreography:**
```
Service A → Event → Service B → Event → Service C
```
Decentralized, services react to events

**Orchestration:**
```
Saga Orchestrator
    |
    ├→ Service A
    ├→ Service B
    └→ Service C
```
Centralized coordinator

---

## Message Queues and Event Streaming

### Message Queue Patterns

#### 1. **Point-to-Point**

```
Producer → Queue → Consumer
```
One message, one consumer

#### 2. **Publish-Subscribe**

```
      Topic
     /  |  \
    C1  C2  C3
```
One message, multiple consumers

### Kafka Architecture

```
Producers → Kafka Cluster → Consumers
            /    |    \
        Broker1 Broker2 Broker3
           |
        Topic: Orders
        ├─ Partition 0 (Leader: B1, Replicas: B2, B3)
        ├─ Partition 1 (Leader: B2, Replicas: B1, B3)
        └─ Partition 2 (Leader: B3, Replicas: B1, B2)
```

**Key Concepts:**

**Topics & Partitions:**
```
Topic: user-events
├─ Partition 0: [E1, E2, E5, E8]
├─ Partition 1: [E3, E6, E9, E12]
└─ Partition 2: [E4, E7, E10, E11]
```

**Consumer Groups:**
```
Consumer Group: analytics
├─ Consumer 1 → Partition 0, 1
└─ Consumer 2 → Partition 2

Consumer Group: alerts
└─ Consumer 3 → Partition 0, 1, 2
```

**Offsets:**
```
Partition 0: [0][1][2][3][4][5][6]
                      ↑
                Consumer offset = 3
```

**Example:**

```java
// Producer
Properties props = new Properties();
props.put("bootstrap.servers", "localhost:9092");
props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

KafkaProducer<String, String> producer = new KafkaProducer<>(props);

ProducerRecord<String, String> record = 
    new ProducerRecord<>("orders", "order-123", orderJson);

producer.send(record, (metadata, exception) -> {
    if (exception != null) {
        log.error("Error producing message", exception);
    } else {
        log.info("Sent to partition {} with offset {}", 
                 metadata.partition(), metadata.offset());
    }
});

// Consumer
Properties props = new Properties();
props.put("bootstrap.servers", "localhost:9092");
props.put("group.id", "order-processor");
props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");

KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
consumer.subscribe(Arrays.asList("orders"));

while (true) {
    ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100));
    for (ConsumerRecord<String, String> record : records) {
        processOrder(record.value());
        // Commit offset after processing
        consumer.commitSync();
    }
}
```

### Delivery Guarantees

**At-Most-Once:**
```
Receive → Process → Commit offset
(Crash before process = message lost)
```

**At-Least-Once:**
```
Receive → Commit offset → Process
(Crash before commit = reprocess message)
```

**Exactly-Once:**
```
Transactional processing + idempotent producer
```

---

## Service Discovery

### Why Service Discovery?

- Dynamic IP addresses (cloud, containers)
- Auto-scaling adds/removes instances
- Health checks route to healthy instances

### Patterns

#### 1. **Client-Side Discovery**

```
Client → Service Registry (get addresses)
       → Service Instance (direct call)
```

**Example: Eureka**

```java
// Service Registration
@EnableEurekaClient
@SpringBootApplication
public class OrderServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(OrderServiceApplication.class, args);
    }
}

// application.yml
eureka:
  client:
    serviceUrl:
      defaultZone: http://localhost:8761/eureka/
  instance:
    preferIpAddress: true

// Service Discovery
@Autowired
private DiscoveryClient discoveryClient;

public List<ServiceInstance> getInventoryInstances() {
    return discoveryClient.getInstances("inventory-service");
}
```

#### 2. **Server-Side Discovery**

```
Client → Load Balancer → Service Instance
              ↑
         Service Registry
```

**Example: Kubernetes**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: order-service
spec:
  selector:
    app: order
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer
```

### Service Registry Implementations

- **Eureka** (Netflix)
- **Consul** (HashiCorp)
- **etcd** (CoreOS)
- **ZooKeeper** (Apache)
- **Kubernetes DNS**

---

## Load Balancing

### Algorithms

#### 1. **Round Robin**
```
Request 1 → Server A
Request 2 → Server B
Request 3 → Server C
Request 4 → Server A (cycle repeats)
```

#### 2. **Least Connections**
```
Server A: 10 connections
Server B: 5 connections  ← Route here
Server C: 8 connections
```

#### 3. **Weighted Round Robin**
```
Server A (weight=3): 60% traffic
Server B (weight=1): 20% traffic
Server C (weight=1): 20% traffic
```

#### 4. **Consistent Hashing**
```
Hash(request) → Server on hash ring
```

#### 5. **Least Response Time**
```
Server A: avg 100ms
Server B: avg 50ms  ← Route here
Server C: avg 200ms
```

### Implementation Layers

**L4 (Transport Layer):**
- TCP/UDP load balancing
- Fast, no application awareness
- **Tools**: HAProxy, NGINX

**L7 (Application Layer):**
- HTTP/HTTPS load balancing
- Content-based routing
- **Tools**: NGINX, Envoy, AWS ALB

### Example (NGINX)

```nginx
upstream backend {
    least_conn;  # Algorithm
    
    server backend1.example.com weight=3;
    server backend2.example.com weight=1;
    server backend3.example.com backup;  # Fallback
    
    # Health check
    check interval=3000 rise=2 fall=5 timeout=1000;
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

---

## Distributed Caching

### Cache Strategies

#### 1. **Cache-Aside (Lazy Loading)**

```
Read:
Client → Cache (miss) → Database → Cache (write) → Client

Write:
Client → Database → Cache (invalidate)
```

```java
public User getUser(String userId) {
    // Try cache first
    User user = cache.get(userId);
    if (user == null) {
        // Cache miss: load from DB
        user = database.findUserById(userId);
        // Populate cache
        cache.put(userId, user);
    }
    return user;
}

public void updateUser(User user) {
    database.save(user);
    cache.evict(user.getId());  // Invalidate
}
```

#### 2. **Write-Through**

```
Write:
Client → Cache → Database
```
Cache updated synchronously

#### 3. **Write-Behind (Write-Back)**

```
Write:
Client → Cache (immediate return)
       → Database (async, batched)
```

#### 4. **Refresh-Ahead**

```
Before expiry:
Cache → Database (proactive refresh)
```

### Distributed Cache Systems

#### Redis

```java
@Autowired
private RedisTemplate<String, Object> redisTemplate;

public void cacheUser(User user) {
    redisTemplate.opsForValue()
        .set("user:" + user.getId(), user, 1, TimeUnit.HOURS);
}

public User getUser(String userId) {
    return (User) redisTemplate.opsForValue()
        .get("user:" + userId);
}
```

#### Memcached

```java
MemcachedClient client = new MemcachedClient(
    new InetSocketAddress("localhost", 11211));

client.set("user:123", 3600, userObject);
Object user = client.get("user:123");
```

### Cache Invalidation Strategies

1. **TTL (Time-To-Live)**: Expire after time
2. **Event-Based**: Invalidate on updates
3. **Version-Based**: Tag cache entries
4. **LRU (Least Recently Used)**: Evict old entries

### Cache Consistency

**Problem:**
```
Node 1 Cache: user=v1
Node 2 Cache: user=v1
Database: user=v2 (updated)
```

**Solutions:**
- Cache invalidation
- Short TTLs
- Pub/Sub for cache updates

```java
// Redis Pub/Sub for cache invalidation
redisTemplate.convertAndSend("cache-invalidation", "user:123");

@RedisListener(topics = "cache-invalidation")
public void handleInvalidation(String key) {
    localCache.evict(key);
}
```

---

## Observability

### Three Pillars

#### 1. **Logging**

Structured logs across services.

```java
@Slf4j
public class OrderService {
    public Order createOrder(OrderRequest request) {
        MDC.put("orderId", generateOrderId());
        MDC.put("userId", request.getUserId());
        
        log.info("Creating order", 
                 kv("productId", request.getProductId()),
                 kv("quantity", request.getQuantity()));
        
        try {
            Order order = processOrder(request);
            log.info("Order created successfully");
            return order;
        } catch (Exception e) {
            log.error("Order creation failed", e);
            throw e;
        } finally {
            MDC.clear();
        }
    }
}
```

**Centralized Logging:**
```
Services → Log Shipper (Filebeat) → Log Aggregator (Logstash) → Elasticsearch → Kibana
```

#### 2. **Metrics**

Quantitative measurements.

```java
@Component
public class OrderMetrics {
    private final Counter ordersCreated;
    private final Timer orderProcessingTime;
    private final Gauge activeOrders;
    
    public OrderMetrics(MeterRegistry registry) {
        this.ordersCreated = registry.counter("orders.created");
        this.orderProcessingTime = registry.timer("orders.processing.time");
        this.activeOrders = registry.gauge("orders.active", new AtomicInteger(0));
    }
    
    public void recordOrderCreated() {
        ordersCreated.increment();
    }
    
    public void recordProcessingTime(Duration duration) {
        orderProcessingTime.record(duration);
    }
}
```

**Metrics Stack:**
```
Services → Prometheus (scrape) → Grafana (visualize)
```

#### 3. **Tracing**

Request flow across services.

```java
@Autowired
private Tracer tracer;

public Order createOrder(OrderRequest request) {
    Span span = tracer.nextSpan().name("create-order").start();
    try (Tracer.SpanInScope ws = tracer.withSpan(span)) {
        span.tag("orderId", orderId);
        span.tag("userId", request.getUserId());
        
        // Call inventory service
        Span inventorySpan = tracer.nextSpan(span)
            .name("check-inventory").start();
        try {
            inventoryClient.checkStock(request.getProductId());
        } finally {
            inventorySpan.end();
        }
        
        // Process order
        return processOrder(request);
    } finally {
        span.end();
    }
}
```

**Distributed Tracing:**
```
User Request → Order Service → Inventory Service → Database
   TraceId: 123    SpanId: 1      SpanId: 2         SpanId: 3
                   Parent: -       Parent: 1         Parent: 2
```

**Tools:**
- **Jaeger**
- **Zipkin**
- **OpenTelemetry**

---

## Common Challenges

### 1. **Network Partitions**

**Problem**: Network splits cluster.

**Solutions:**
- Quorum-based decisions
- Graceful degradation
- Monitor partition recovery

### 2. **Clock Synchronization**

**Problem**: No global clock.

**Solutions:**
- Logical clocks (Lamport timestamps)
- Vector clocks
- NTP synchronization
- TrueTime (Google Spanner)

### 3. **Data Consistency**

**Problem**: Keeping replicas in sync.

**Solutions:**
- Choose consistency model
- Conflict resolution strategies
- Version vectors

### 4. **Cascading Failures**

**Problem**: One failure triggers others.

**Solutions:**
- Circuit breakers
- Bulkheads
- Rate limiting
- Timeouts

### 5. **Monitoring Complexity**

**Problem**: Many services to monitor.

**Solutions:**
- Centralized observability
- Service mesh
- Automated alerting

---

## Real-World Systems

### 1. **Google Spanner**

- **Consistency**: Linearizable
- **Scalability**: Global scale
- **Tech**: TrueTime API for global clock
- **Use case**: Advertising, Google Play

### 2. **Amazon DynamoDB**

- **Consistency**: Eventual (tunable)
- **Partitioning**: Consistent hashing
- **Replication**: Multi-region
- **Use case**: E-commerce, gaming

### 3. **Apache Cassandra**

- **Consistency**: Tunable quorums
- **Architecture**: Peer-to-peer
- **Partitioning**: Consistent hashing
- **Use case**: Time-series, IoT

### 4. **Netflix Microservices**

- **Service Discovery**: Eureka
- **Load Balancing**: Ribbon
- **Circuit Breaker**: Hystrix
- **API Gateway**: Zuul

### 5. **Uber's Microservices**

- **RPC**: TChannel
- **Service Mesh**: Custom
- **Tracing**: Jaeger
- **Databases**: Schemaless (MySQL + blob store)

---

## Summary

**Key Takeaways:**

1. **CAP Theorem**: Choose 2 of 3 (Consistency, Availability, Partition Tolerance)
2. **Consistency Models**: Trade-off between consistency and performance
3. **Partitioning**: Essential for scaling beyond single machine
4. **Replication**: Critical for availability and fault tolerance
5. **Consensus**: Raft/Paxos for coordinating distributed state
6. **Patterns**: Choose appropriate patterns for your use case
7. **Observability**: Logs, metrics, traces are essential
8. **Failure Handling**: Design for failure from day one

**Design Principles:**

- **Expect failures**: Design for partial failures
- **Keep it simple**: Complexity is the enemy
- **Monitor everything**: Visibility is crucial
- **Gradual rollout**: Test changes incrementally
- **Immutability**: Prefer immutable data structures
- **Idempotency**: Operations should be safely retryable

**Remember**: There's no silver bullet. Every design involves trade-offs based on your specific requirements.
